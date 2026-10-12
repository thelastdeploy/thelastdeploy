// cmd/stop.go
package cmd

import (
	"fmt"
	"os"
	"syscall"

	"github.com/thelastdeploy/agent/internal/lab"
	"github.com/thelastdeploy/agent/internal/localserver"
)

func runStop(args []string) error {
	if os.Getenv("TLD_IN_CONTAINER") == "1" {
		_ = os.WriteFile("/tld/stopped", []byte("stopped"), 0644)
		fmt.Println("✓ Stopping lab session and destroying container...")
		ppid := os.Getppid()
		if ppid > 1 {
			_ = syscall.Kill(ppid, syscall.SIGKILL)
		}
		os.Exit(0)
		return nil
	}

	// Stop the lab environment (tears down docker/kind/shell, clears session).
	if err := lab.Stop(); err != nil {
		return err
	}
	// Shut down the background local server if it is running.
	localserver.Shutdown()
	return nil
}
