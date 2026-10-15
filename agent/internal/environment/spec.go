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
	Privileged   bool     `json:"privileged,omitempty" yaml:"privileged,omitempty"`
}

// ResolveInstanceSpec computes the runtime instance configuration for a lab container.
func ResolveInstanceSpec(labID string, envSpec *EnvironmentSpec) *runtime.InstanceSpec {
	profileName := DefaultProfile
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

	requiresPrivileged := profile.RequiresPrivileged
	if envSpec != nil && envSpec.Privileged {
		requiresPrivileged = true
	}

	return &runtime.InstanceSpec{
		InstanceID:         instanceID,
		Image:              profile.BaseImage,
		RequiresSystemd:    profile.RequiresSystemd,
		RequiresPrivileged: requiresPrivileged,
		Capabilities:       caps,
		Ports:              ports,
		WorkspaceDir:       "/workspace",
	}
}

// GetProfilesForModules returns a deduplicated list of base images required to run labs.
func GetProfilesForModules(moduleIDs []string) []string {
	return []string{GetProfile(DefaultProfile).BaseImage}
}
