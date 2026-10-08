// agent/internal/environment/spec.go
package environment

import (
	"strings"

	"github.com/thelastdeploy/agent/internal/runtime"
)

type EnvironmentSpec struct {
	Profile      string   `json:"profile" yaml:"profile"`
	Packages     []string `json:"packages" yaml:"packages"`
	Capabilities []string `json:"capabilities" yaml:"capabilities"`
	Ports        []string `json:"ports" yaml:"ports"`
}

func ResolveInstanceSpec(labID string, envSpec *EnvironmentSpec) *runtime.InstanceSpec {
	profileName := "ubuntu-24.04-standard"
	if envSpec != nil && envSpec.Profile != "" {
		profileName = envSpec.Profile
	}

	profile := GetProfile(profileName)

	instanceID := "tld-lab-" + strings.ToLower(labID)
	instanceID = strings.Map(func(r rune) rune {
		if (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z') || (r >= '0' && r <= '9') || r == '-' {
			return r
		}
		return '-'
	}, instanceID)

	var caps []string
	var ports []string

	if envSpec != nil {
		caps = envSpec.Capabilities
		ports = envSpec.Ports
	}

	return &runtime.InstanceSpec{
		InstanceID:      instanceID,
		Image:           profile.BaseImage,
		RequiresSystemd: profile.RequiresSystemd,
		Capabilities:    caps,
		Ports:           ports,
		WorkspaceDir:    "/workspace",
	}
}
