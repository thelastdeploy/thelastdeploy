// agent/cmd/attach.go
package cmd

import (
	"fmt"
	"os"

	"github.com/thelastdeploy/agent/internal/lab"
)

func runAttach(args []string) error {
	if os.Getenv("TLD_IN_CONTAINER") == "1" {
		fmt.Println("ℹ️  You are already inside the active lab container shell.")
		return nil
	}

	if err := lab.Attach(); err != nil {
		return fmt.Errorf("attach: %w", err)
	}
	return nil
}
