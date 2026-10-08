// agent/internal/runtime/docker/docker.go
package docker

import (
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/thelastdeploy/agent/internal/runtime"
)

type DockerEngine struct{}

func New() *DockerEngine {
	return &DockerEngine{}
}

func (d *DockerEngine) Name() string {
	return "docker"
}

func (d *DockerEngine) IsAvailable(ctx context.Context) error {
	cmd := exec.CommandContext(ctx, "docker", "info")
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("Docker is not available.\n  Please make sure the Docker daemon is running and try again.")
	}
	return nil
}

func (d *DockerEngine) Create(ctx context.Context, spec *runtime.InstanceSpec) (string, error) {
	if err := d.IsAvailable(ctx); err != nil {
		return "", err
	}

	// Remove existing container with same name if stale
	_ = d.Destroy(ctx, spec.InstanceID)

	args := []string{
		"run", "-d",
		"--name", spec.InstanceID,
		"--rm",
	}

	for _, port := range spec.Ports {
		args = append(args, "-p", port)
	}

	for _, cap := range spec.Capabilities {
		args = append(args, "--cap-add", cap)
	}

	for k, v := range spec.EnvironmentVars {
		args = append(args, "-e", fmt.Sprintf("%s=%s", k, v))
	}

	if spec.RequiresSystemd {
		args = append(args,
			"--cgroupns=host",
			"-v", "/sys/fs/cgroup:/sys/fs/cgroup:rw",
			"--tmpfs", "/run",
			"--tmpfs", "/run/lock",
		)
	}

	args = append(args, spec.Image, "sleep", "infinity")

	cmd := exec.CommandContext(ctx, "docker", args...)
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "", fmt.Errorf("failed to create Docker container: %w\n%s", err, strings.TrimSpace(string(out)))
	}

	return spec.InstanceID, nil
}

func (d *DockerEngine) Exec(ctx context.Context, instanceID string, command []string) (runtime.ExecResult, error) {
	args := append([]string{"exec", instanceID}, command...)
	cmd := exec.CommandContext(ctx, "docker", args...)

	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	err := cmd.Run()
	exitCode := 0
	if err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok {
			exitCode = exitErr.ExitCode()
		} else {
			return runtime.ExecResult{}, fmt.Errorf("docker exec failed: %w", err)
		}
	}

	return runtime.ExecResult{
		ExitCode: exitCode,
		Stdout:   strings.TrimSpace(stdout.String()),
		Stderr:   strings.TrimSpace(stderr.String()),
	}, nil
}

func (d *DockerEngine) Attach(ctx context.Context, instanceID string) error {
	cmd := exec.CommandContext(ctx, "docker", "exec", "-it", instanceID, "/bin/bash")
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func (d *DockerEngine) Destroy(ctx context.Context, instanceID string) error {
	if instanceID == "" {
		return nil
	}
	cmd := exec.CommandContext(ctx, "docker", "rm", "-f", instanceID)
	out, err := cmd.CombinedOutput()
	if err != nil {
		outStr := string(out)
		if strings.Contains(outStr, "No such container") || strings.Contains(outStr, "not found") {
			return nil
		}
		return fmt.Errorf("docker rm failed: %w\n%s", err, strings.TrimSpace(outStr))
	}
	return nil
}

func (d *DockerEngine) CopyFileToInstance(ctx context.Context, instanceID string, hostPath string, instancePath string) error {
	cmd := exec.CommandContext(ctx, "docker", "cp", hostPath, fmt.Sprintf("%s:%s", instanceID, instancePath))
	out, err := cmd.CombinedOutput()
	if err != nil {
		return fmt.Errorf("docker cp failed: %w\n%s", err, strings.TrimSpace(string(out)))
	}
	return nil
}
