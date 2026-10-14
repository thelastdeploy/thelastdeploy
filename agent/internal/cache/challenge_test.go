// agent/internal/cache/challenge_test.go
package cache

import (
	"os"
	"path/filepath"
	"testing"
)

func TestParseModuleYAMLSharedSeed(t *testing.T) {
	yamlContent := `id: nginx-test
title: "Nginx Test"
shared_seed:
  - "systemctl start nginx"
  - "mkdir -p /var/www/html"
`
	tmpDir := t.TempDir()
	yamlPath := filepath.Join(tmpDir, "module.yaml")
	if err := os.WriteFile(yamlPath, []byte(yamlContent), 0644); err != nil {
		t.Fatalf("failed to write test module.yaml: %v", err)
	}

	mod, err := ParseModuleYAML(yamlPath)
	if err != nil {
		t.Fatalf("ParseModuleYAML failed: %v", err)
	}

	if mod.ID != "nginx-test" {
		t.Errorf("expected module ID nginx-test, got %s", mod.ID)
	}

	if len(mod.SharedSeed) != 2 {
		t.Fatalf("expected 2 shared_seed commands, got %d", len(mod.SharedSeed))
	}

	if mod.SharedSeed[0] != "systemctl start nginx" {
		t.Errorf("unexpected seed[0]: %s", mod.SharedSeed[0])
	}
	if mod.SharedSeed[1] != "mkdir -p /var/www/html" {
		t.Errorf("unexpected seed[1]: %s", mod.SharedSeed[1])
	}
}

func TestParseLabYAMLInstallTarget(t *testing.T) {
	yamlContent := `id: test-install-lab
title: "Install Test Lab"
install_target: nginx
setup:
  type: shell
  seed_commands:
    - "echo 'ready'"
`
	tmpDir := t.TempDir()
	yamlPath := filepath.Join(tmpDir, "lab.yaml")
	if err := os.WriteFile(yamlPath, []byte(yamlContent), 0644); err != nil {
		t.Fatalf("failed to write test lab.yaml: %v", err)
	}

	lab, err := parseLabYAML(yamlPath)
	if err != nil {
		t.Fatalf("parseLabYAML failed: %v", err)
	}

	if lab.InstallTarget != "nginx" {
		t.Errorf("expected install_target 'nginx', got %q", lab.InstallTarget)
	}

	if len(lab.SeedCommands) != 1 || lab.SeedCommands[0] != "echo 'ready'" {
		t.Errorf("unexpected seed commands: %v", lab.SeedCommands)
	}
}
