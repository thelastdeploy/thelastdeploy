// agent/internal/environment/environment_test.go
package environment

import (
	"testing"
)

func TestProfileResolution(t *testing.T) {
	pStandard := GetProfile("ubuntu-24.04-standard")
	if pStandard == nil || pStandard.RequiresSystemd {
		t.Errorf("expected ubuntu-24.04-standard to exist and not require systemd")
	}

	pSystemd := GetProfile("ubuntu-24.04-systemd")
	if pSystemd == nil || !pSystemd.RequiresSystemd {
		t.Errorf("expected ubuntu-24.04-systemd to exist and require systemd")
	}

	pFallback := GetProfile("non-existent-profile")
	if pFallback == nil || pFallback.Name != "ubuntu-24.04-standard" {
		t.Errorf("expected non-existent profile to fallback to ubuntu-24.04-standard")
	}
}

func TestResolveInstanceSpec(t *testing.T) {
	spec := &EnvironmentSpec{
		Profile:      "ubuntu-24.04-systemd",
		Packages:     []string{"nginx"},
		Capabilities: []string{"NET_ADMIN"},
		Ports:        []string{"8080:80"},
	}

	instanceSpec := ResolveInstanceSpec("lnx-test-lab", spec)
	if instanceSpec.InstanceID != "tld-lab-lnx-test-lab" {
		t.Errorf("unexpected InstanceID: %s", instanceSpec.InstanceID)
	}

	if !instanceSpec.RequiresSystemd {
		t.Errorf("expected RequiresSystemd to be true for systemd profile")
	}

	if len(instanceSpec.Capabilities) != 1 || instanceSpec.Capabilities[0] != "NET_ADMIN" {
		t.Errorf("unexpected capabilities: %v", instanceSpec.Capabilities)
	}

	if len(instanceSpec.Ports) != 1 || instanceSpec.Ports[0] != "8080:80" {
		t.Errorf("unexpected ports: %v", instanceSpec.Ports)
	}
}
