// cmd/version.go
package cmd

import (
	"fmt"
	"runtime"

	"github.com/thelastdeploy/agent/internal/config"
)

var Version = "v1.1.0"

func runVersion(args []string) error {
	cfg, _ := config.Load()
	envMode := "production"
	if cfg != nil && config.IsDevEnv(cfg) {
		envMode = "local dev"
	}
	fmt.Printf("tld CLI %s [%s] (%s/%s)\n", Version, envMode, runtime.GOOS, runtime.GOARCH)
	return nil
}
