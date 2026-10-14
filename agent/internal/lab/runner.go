// internal/lab/runner.go
package lab

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/thelastdeploy/agent/internal/cache"
	"github.com/thelastdeploy/agent/internal/config"
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

	instanceSpec := environment.ResolveInstanceSpec(lab.ModuleID, lab.ID, lab.Environment)
	if instanceSpec.EnvironmentVars == nil {
		instanceSpec.EnvironmentVars = make(map[string]string)
	}
	instanceSpec.EnvironmentVars["TLD_IN_CONTAINER"] = "1"
	instanceSpec.EnvironmentVars["DEBIAN_FRONTEND"] = "noninteractive"

	fmt.Printf("🐳 Checking lab environment image (%s)...\n", instanceSpec.Image)
	if err := eng.Pull(ctx, instanceSpec.Image); err != nil {
		fmt.Fprintf(os.Stderr, "  info: using local image: %v\n", err)
	}

	fmt.Printf("⚙  Provisioning disposable container environment (%s)...\n", instanceSpec.Image)
	containerID, err := eng.Create(ctx, instanceSpec)
	if err != nil {
		return fmt.Errorf("failed to create environment: %w", err)
	}

	if instanceSpec.RequiresSystemd {
		fmt.Println("  ⏳ Waiting for container init services...")
		for i := 0; i < 20; i++ {
			time.Sleep(300 * time.Millisecond)
			res, err := eng.Exec(ctx, containerID, []string{"systemctl", "is-system-running"})
			if err == nil && (res.Stdout == "running" || res.Stdout == "degraded") {
				break
			}
		}
	}

	// Ensure sudo wrapper exists for root container execution
	_, _ = eng.Exec(ctx, containerID, []string{"/bin/bash", "-c", "echo '#!/bin/sh\nexec \"$@\"' > /usr/local/bin/sudo && chmod +x /usr/local/bin/sudo"})

	// Inject in-container tld binary, config, validator, and active session
	injectInContainerTLD(ctx, eng, containerID, lab)

	// Strip pre-installed package for labs specifically testing installation
	if lab.InstallTarget != "" {
		fmt.Printf("  🔧 Lab requires you to install %s — removing pre-installed package...\n", lab.InstallTarget)
		_, _ = eng.Exec(ctx, containerID, []string{"/bin/bash", "-c", fmt.Sprintf("DEBIAN_FRONTEND=noninteractive apt-get remove -y %s && apt-get autoremove -y", lab.InstallTarget)})
	}

	// Prepare environment packages if needed
	if lab.Environment != nil && len(lab.Environment.Packages) > 0 {
		fmt.Printf("  📦 Installing required lab packages (%s)...\n", fmt.Sprint(lab.Environment.Packages))
		_, _ = eng.Exec(ctx, containerID, []string{"/bin/bash", "-c", "DEBIAN_FRONTEND=noninteractive apt-get update -qq"})
		pkgList := strings.Join(lab.Environment.Packages, " ")
		installCmd := []string{"/bin/bash", "-c", "DEBIAN_FRONTEND=noninteractive apt-get install -y -qq " + pkgList}
		if res, err := eng.Exec(ctx, containerID, installCmd); err != nil || res.ExitCode != 0 {
			fmt.Fprintf(os.Stderr, "  warn: package installation notice: %s %s\n", res.Stdout, res.Stderr)
		}
	}

	// 1. Run module shared baseline commands INSIDE container
	if len(lab.ModuleSharedSeed) > 0 {
		fmt.Println("⚙  Applying module environment baseline inside container...")
		for _, cmdStr := range lab.ModuleSharedSeed {
			fmt.Printf("  $ %s\n", cmdStr)
			res, err := eng.Exec(ctx, containerID, []string{"/bin/bash", "-c", cmdStr})
			if err != nil || res.ExitCode != 0 {
				fmt.Fprintf(os.Stderr, "  warn: shared seed command exited with code %d: %s\n", res.ExitCode, res.Stderr)
			}
		}
		fmt.Println()
	}

	// 2. Run seed commands INSIDE container
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
	fmt.Println("👉 Run 'tld check' right here inside this shell whenever you are ready to validate.")
	fmt.Println("👉 Run 'tld stop' or type 'exit' when finished.")

	_ = eng.Attach(ctx, containerID)

	// Check if user ran 'tld stop' inside the container
	chkRes, chkErr := eng.Exec(ctx, containerID, []string{"test", "-f", "/tld/stopped"})
	if chkErr == nil && chkRes.ExitCode == 0 {
		return Stop()
	}
	return nil
}

func injectInContainerTLD(ctx context.Context, eng *docker.DockerEngine, containerID string, l *cache.Lab) {
	// 1. Ensure required base directories exist
	_, _ = eng.Exec(ctx, containerID, []string{"mkdir", "-p", "/usr/local/bin", "/tld", "/root/.tld"})

	// 2. Inject host tld binary
	if hostExe, err := os.Executable(); err == nil {
		if resolved, err := filepath.EvalSymlinks(hostExe); err == nil {
			hostExe = resolved
		}
		if err := eng.CopyFileToInstance(ctx, containerID, hostExe, "/usr/local/bin/tld"); err == nil {
			_, _ = eng.Exec(ctx, containerID, []string{"chmod", "+x", "/usr/local/bin/tld"})
		}
	}

	// 3. Pre-stage validator script
	targetScript := "/tld/validator.sh"
	if strings.HasSuffix(l.ValidatorPath, ".py") {
		targetScript = "/tld/validator.py"
	}
	if err := eng.CopyFileToInstance(ctx, containerID, l.ValidatorPath, targetScript); err == nil {
		_, _ = eng.Exec(ctx, containerID, []string{"chmod", "+x", targetScript})
	}

	// 4. Inject config and device.key
	if cfg, err := config.Load(); err == nil {
		containerAPIBaseURL := cfg.APIBaseURL
		if strings.Contains(containerAPIBaseURL, "localhost") || strings.Contains(containerAPIBaseURL, "127.0.0.1") {
			containerAPIBaseURL = strings.Replace(containerAPIBaseURL, "localhost", "host.docker.internal", 1)
			containerAPIBaseURL = strings.Replace(containerAPIBaseURL, "127.0.0.1", "host.docker.internal", 1)
		}
		containerCfg := fmt.Sprintf("# In-container TLD config\nenvironment: %s\napi_base_url: %s\ndevice_key_path: /root/.tld/device.key\nchallenges_dir: /tld/challenges\nchallenges_repo: %s\nauth_token: %s\nusername: %s\n",
			cfg.Environment, containerAPIBaseURL, cfg.ChallengesRepo, cfg.AuthToken, cfg.Username)

		if tmpCfgFile, err := os.CreateTemp("", "tld-cfg-*.yaml"); err == nil {
			tmpCfgPath := tmpCfgFile.Name()
			_, _ = tmpCfgFile.WriteString(containerCfg)
			_ = tmpCfgFile.Close()
			_ = eng.CopyFileToInstance(ctx, containerID, tmpCfgPath, "/root/.tld/config.yaml")
			_ = os.Remove(tmpCfgPath)
		}

		if _, err := os.Stat(cfg.DeviceKeyPath); err == nil {
			_ = eng.CopyFileToInstance(ctx, containerID, cfg.DeviceKeyPath, "/root/.tld/device.key")
		}
	}

	// 5. In-container active session
	containerSession := &Session{
		LabID:         l.ID,
		ModuleID:      l.ModuleID,
		SectionID:     l.SectionID,
		StartedAt:     time.Now(),
		ValidatorPath: targetScript,
		SetupType:     l.SetupType,
		ContainerID:   containerID,
	}
	if tmpSessData, err := json.MarshalIndent(containerSession, "", "  "); err == nil {
		if tmpSessFile, err := os.CreateTemp("", "tld-sess-*.json"); err == nil {
			tmpSessPath := tmpSessFile.Name()
			_, _ = tmpSessFile.Write(tmpSessData)
			_ = tmpSessFile.Close()
			_ = eng.CopyFileToInstance(ctx, containerID, tmpSessPath, "/root/.tld/session.json")
			_ = os.Remove(tmpSessPath)
		}
	}

	// 6. Mirror config/session into .tld-dev and ensure non-root users have access
	_, _ = eng.Exec(ctx, containerID, []string{"/bin/bash", "-c", "rm -rf /root/.tld-dev && cp -r /root/.tld /root/.tld-dev"})
	_, _ = eng.Exec(ctx, containerID, []string{"/bin/bash", "-c", "if [ -d /home/ubuntu ]; then cp -r /root/.tld /home/ubuntu/.tld && cp -r /root/.tld /home/ubuntu/.tld-dev && chown -R ubuntu:ubuntu /home/ubuntu/.tld /home/ubuntu/.tld-dev; fi"})

	// 7. Inject CA certificates if available on host so outbound HTTPS functions cleanly
	if _, err := os.Stat("/etc/ssl/certs/ca-certificates.crt"); err == nil {
		_, _ = eng.Exec(ctx, containerID, []string{"mkdir", "-p", "/etc/ssl/certs"})
		_ = eng.CopyFileToInstance(ctx, containerID, "/etc/ssl/certs/ca-certificates.crt", "/etc/ssl/certs/ca-certificates.crt")
	}
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
	attachErr := eng.Attach(ctx, session.ContainerID)
	chkRes, chkErr := eng.Exec(ctx, session.ContainerID, []string{"test", "-f", "/tld/stopped"})
	if chkErr == nil && chkRes.ExitCode == 0 {
		return Stop()
	}
	return attachErr
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

func shortID(id string) string {
	if len(id) > 12 {
		return id[:12]
	}
	return id
}
