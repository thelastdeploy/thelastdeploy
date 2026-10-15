// agent/internal/environment/environment_test.go
package environment

import (
	"testing"
)

func TestProfileResolution(t *testing.T) {
	pUbuntu := GetProfile("tld-ubuntu")
	if pUbuntu == nil || !pUbuntu.RequiresSystemd {
		t.Errorf("expected tld-ubuntu to exist and require systemd")
	}

	pDind := GetProfile("tld-dind")
	if pDind == nil || !pDind.RequiresPrivileged {
		t.Errorf("expected tld-dind to exist and require privileged")
	}

	pKind := GetProfile("tld-kind")
	if pKind == nil || !pKind.RequiresPrivileged {
		t.Errorf("expected tld-kind to exist and require privileged")
	}

	pFallback := GetProfile("non-existent-profile")
	if pFallback == nil || pFallback.Name != "tld-ubuntu" {
		t.Errorf("expected non-existent profile to fallback to tld-ubuntu")
	}
}

func TestResolveInstanceSpec(t *testing.T) {
	// Test 1: Default resolution (no profile specified -> tld-ubuntu)
	defaultSpec := ResolveInstanceSpec("test-lab-default", nil)
	if defaultSpec.InstanceID != "tld-lab-test-lab-default" {
		t.Errorf("unexpected InstanceID: %s", defaultSpec.InstanceID)
	}
	if defaultSpec.Image != "ghcr.io/thelastdeploy/tld-ubuntu:latest" {
		t.Errorf("expected default image to be tld-ubuntu, got %s", defaultSpec.Image)
	}

	// Test 2: Explicit profile
	spec := &EnvironmentSpec{
		Profile:      "tld-dind",
		Packages:     []string{"htop"},
		Capabilities: []string{"NET_ADMIN"},
		Ports:        []string{"8080:80"},
	}

	instanceSpec := ResolveInstanceSpec("dind-test-lab", spec)
	if instanceSpec.InstanceID != "tld-lab-dind-test-lab" {
		t.Errorf("unexpected InstanceID: %s", instanceSpec.InstanceID)
	}

	if !instanceSpec.RequiresPrivileged {
		t.Errorf("expected RequiresPrivileged to be true for dind profile")
	}

	if len(instanceSpec.Capabilities) != 1 || instanceSpec.Capabilities[0] != "NET_ADMIN" {
		t.Errorf("unexpected capabilities: %v", instanceSpec.Capabilities)
	}

	if len(instanceSpec.Ports) != 1 || instanceSpec.Ports[0] != "8080:80" {
		t.Errorf("unexpected ports: %v", instanceSpec.Ports)
	}
}
