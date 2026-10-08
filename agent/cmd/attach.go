// agent/cmd/attach.go
package cmd

import (
	"fmt"

	"github.com/thelastdeploy/agent/internal/lab"
)

func runAttach(args []string) error {
	if err := lab.Attach(); err != nil {
		return fmt.Errorf("attach: %w", err)
	}
	return nil
}
