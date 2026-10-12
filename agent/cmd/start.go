// cmd/start.go
package cmd

import (
	"errors"
	"fmt"
	"os"
	"strings"

	"github.com/thelastdeploy/agent/internal/cache"
	"github.com/thelastdeploy/agent/internal/config"
	"github.com/thelastdeploy/agent/internal/lab"
	"github.com/thelastdeploy/agent/internal/localserver"
)

func runStart(args []string) error {
	if os.Getenv("TLD_IN_CONTAINER") == "1" {
		fmt.Println("ℹ️  You are already inside an active lab container!")
		fmt.Println("   Run 'tld check' to validate your work, or 'tld stop' / 'exit' when finished.")
		return nil
	}

	if len(args) < 1 {
		return errors.New("usage: tld start <lab-id>")
	}
	labID := args[0]

	cfg, err := config.Load()
	if err != nil {
		return fmt.Errorf("load config: %w", err)
	}

	// Find the lab by its globally-unique ID across all modules/sections.
	l, err := cache.FindLab(cfg.ChallengesDir, labID)
	if err != nil {
		return err
	}

	// Check if module is verified. If not, prompt warning.
	if !cache.IsModuleVerified(cfg.ChallengesDir, l.ModuleID) {
		fmt.Printf("\x1b[1;33m⚠️  WARNING: The module '%s' is UNVERIFIED by the TLD team.\x1b[0m\n", l.ModuleID)
		fmt.Println("   Unverified modules may run arbitrary validator or setup commands.")
		fmt.Println("   Please only run if you trust the author.")
		fmt.Print("\n   Do you want to proceed and start the lab? [y/N]: ")

		var response string
		fmt.Scanln(&response)
		response = strings.ToLower(strings.TrimSpace(response))
		if response != "y" && response != "yes" {
			return fmt.Errorf("lab start aborted by user")
		}
	}

	// Start the local server before attaching so it is accessible while the container runs
	if !localserver.IsRunning() {
		srv := localserver.New(cfg.DeviceKeyPath)
		go func() {
			if err := srv.StartBackground(); err != nil {
				fmt.Fprintf(os.Stderr, "warn: local server stopped: %v\n", err)
			}
		}()
		defer localserver.Shutdown()
	}

	if err := lab.Start(l); err != nil {
		return err
	}

	return nil
}
