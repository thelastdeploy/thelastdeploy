// agent/internal/runtime/runtime.go
package runtime

import (
	"context"
)

// ExecResult captures the result of executing a command inside a runtime instance.
type ExecResult struct {
	ExitCode int
	Stdout   string
	Stderr   string
}

// InstanceSpec describes the runtime parameters required to create an environment instance.
type InstanceSpec struct {
	InstanceID      string
	Image           string
	RequiresSystemd bool
	Capabilities    []string
	Ports           []string
	EnvironmentVars map[string]string
	WorkspaceDir    string
}

// Engine defines the contract for runtime execution engines (e.g. Docker).
type Engine interface {
	Name() string
	IsAvailable(ctx context.Context) error
	Create(ctx context.Context, spec *InstanceSpec) (string, error)
	Exec(ctx context.Context, instanceID string, cmd []string) (ExecResult, error)
	Attach(ctx context.Context, instanceID string) error
	Destroy(ctx context.Context, instanceID string) error
	CopyFileToInstance(ctx context.Context, instanceID string, hostPath string, instancePath string) error
}
