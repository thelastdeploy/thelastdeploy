// agent/cmd/logout.go
package cmd

import (
	"fmt"
	"time"

	"github.com/thelastdeploy/agent/internal/config"
)

func runLogout(args []string) error {
	cfg, err := config.Load()
	if err != nil {
		return fmt.Errorf("load config: %w", err)
	}

	if cfg.AuthToken == "" {
		fmt.Println("You are not currently logged in.")
		return nil
	}

	// Revoke the server-side session before wiping local credentials
	_, _, _ = postJSONRequest(cfg.APIBaseURL, "/logout", cfg.AuthToken, nil, 5*time.Second)

	cfg.AuthToken = ""
	if err := config.Save(cfg); err != nil {
		return fmt.Errorf("save config: %w", err)
	}

	fmt.Println("✓ Logged out.")
	fmt.Println("  Run 'tld login' to authenticate again.")
	return nil
}
