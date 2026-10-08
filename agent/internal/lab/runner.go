// internal/lab/runner.go
package lab

import (
	"context"
	"fmt"
	"os"
	"time"

	"github.com/thelastdeploy/agent/internal/cache"
	"github.com/thelastdeploy/agent/internal/environment"
	"github.com/thelastdeploy/agent/internal/runtime/docker"
)

// Start sets up the lab environment in a disposable container.
func Start(lab *cache.Lab) error {
	ctx := context.Background()

	if SessionExists() {
		existing, _ := ReadSession()
		if existing != nil {
			eng := docker.New()
			res, err := eng.Exec(ctx, existing.ContainerID, []string{"echo", "ok"})
			if err == nil && res.ExitCode == 0 {
				return fmt.Errorf("lab '%s' is already running — run 'tld attach' to enter or 'tld stop' to destroy", existing.LabID)
			}
			// Stale session — clean up gracefully
			_ = ClearSession()
		}
	}

	fmt.Printf("\n╔══════════════════════════════════════════════╗\n")
	fmt.Printf("║  The Last Deploy — Starting: %-16s║\n", truncate(lab.Title, 16))
	fmt.Printf("╚══════════════════════════════════════════════╝\n\n")

	eng := docker.New()
	if err := eng.IsAvailable(ctx); err != nil {
		return err
	}

	instanceSpec := environment.ResolveInstanceSpec(lab.ID, lab.Environment)

	fmt.Printf("⚙  Provisioning disposable container environment (%s)...\n", instanceSpec.Image)
	containerID, err := eng.Create(ctx, instanceSpec)
	if err != nil {
		return fmt.Errorf("failed to create environment: %w", err)
	}

	// Ensure sudo wrapper exists for root container execution
	_, _ = eng.Exec(ctx, containerID, []string{"/bin/bash", "-c", "echo '#!/bin/sh\nexec \"$@\"' > /usr/local/bin/sudo && chmod +x /usr/local/bin/sudo"})

	// Prepare environment packages if needed
	if lab.Environment != nil && len(lab.Environment.Packages) > 0 {
		fmt.Printf("  📦 Installing required lab packages (%s)...\n", fmt.Sprint(lab.Environment.Packages))
		_, _ = eng.Exec(ctx, containerID, []string{"apt-get", "update", "-qq"})
		installCmd := append([]string{"apt-get", "install", "-y", "-qq"}, lab.Environment.Packages...)
		if res, err := eng.Exec(ctx, containerID, installCmd); err != nil || res.ExitCode != 0 {
			fmt.Fprintf(os.Stderr, "  warn: package installation notice: %s %s\n", res.Stdout, res.Stderr)
		}
	}

	// Run seed commands INSIDE container
	if len(lab.SeedCommands) > 0 {
		fmt.Println("⚙  Applying lab scenario broken state inside container...")
		for _, cmdStr := range lab.SeedCommands {
			fmt.Printf("  $ %s\n", cmdStr)
			res, err := eng.Exec(ctx, containerID, []string{"/bin/bash", "-c", cmdStr})
			if err != nil || res.ExitCode != 0 {
				fmt.Fprintf(os.Stderr, "  warn: seed command exited with code %d: %s\n", res.ExitCode, res.Stderr)
			}
		}
		fmt.Println()
	}

	session := &Session{
		LabID:         lab.ID,
		ModuleID:      lab.ModuleID,
		SectionID:     lab.SectionID,
		StartedAt:     time.Now(),
		ValidatorPath: lab.ValidatorPath,
		SetupType:     lab.SetupType,
		ContainerID:   containerID,
	}

	if err := WriteSession(session); err != nil {
		_ = eng.Destroy(ctx, containerID)
		return fmt.Errorf("write session: %w", err)
	}

	printLab(lab)

	fmt.Println("Entering interactive lab container shell...")
	fmt.Println("(Type 'exit' to leave shell. Run 'tld check' in another terminal to validate.)")

	_ = eng.Attach(ctx, containerID)
	return nil
}

// Attach connects the terminal to the active lab container shell.
func Attach() error {
	session, err := ReadSession()
	if err != nil {
		return err
	}
	ctx := context.Background()
	eng := docker.New()
	if err := eng.IsAvailable(ctx); err != nil {
		return err
	}
	fmt.Printf("Re-attaching to active lab container (%s)...\n\n", session.LabID)
	return eng.Attach(ctx, session.ContainerID)
}

// Stop tears down the lab container environment and clears the session.
func Stop() error {
	session, err := ReadSession()
	if err != nil {
		return err
	}

	fmt.Printf("Stopping lab: %s\n", session.LabID)
	elapsed := time.Since(session.StartedAt).Round(time.Second)
	fmt.Printf("Session duration: %s\n\n", elapsed)

	ctx := context.Background()
	eng := docker.New()

	fmt.Printf("🧹 Destroying disposable container (%s)...\n", shortID(session.ContainerID))
	if err := eng.Destroy(ctx, session.ContainerID); err != nil {
		fmt.Fprintf(os.Stderr, "warn: destroy container: %v\n", err)
	}

	if err := ClearSession(); err != nil {
		return fmt.Errorf("clear session: %w", err)
	}

	fmt.Println("✓ Lab stopped. Environment cleaned up.")
	return nil
}

func printLab(lab *cache.Lab) {
	fmt.Printf("📋 Lab:      %s\n", lab.Title)
	fmt.Printf("   ID:          %s\n", lab.ID)
	fmt.Printf("   Module:      %s\n", lab.ModuleID)
	fmt.Printf("   Section:     %s\n", lab.SectionID)
	fmt.Printf("   XP reward:   %d\n", lab.XP)
	fmt.Printf("   Est. time:   ~%d minutes\n\n", lab.EstimatedMins)
	fmt.Printf("──────────────────────────────────────────────\n")
	fmt.Printf("When you're done, run:  tld check\n")
	fmt.Printf("To re-enter shell:      tld attach\n")
	fmt.Printf("To stop the lab:        tld stop\n")
	fmt.Printf("──────────────────────────────────────────────\n\n")
}

func truncate(s string, max int) string {
	if len(s) <= max {
		return s
	}
	return s[:max-1] + "…"
}
