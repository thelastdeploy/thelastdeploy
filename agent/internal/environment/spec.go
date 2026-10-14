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

// AutoDetectProfile returns the best-fit profile for a module based on its ID prefix.
func AutoDetectProfile(moduleID string) string {
	switch {
	case strings.HasPrefix(moduleID, "nginx-"):
		return "tld-nginx"
	case strings.HasPrefix(moduleID, "docker-"),
		strings.HasPrefix(moduleID, "container-"):
		return "tld-docker"
	case strings.HasPrefix(moduleID, "k8s-"):
		return "tld-k8s"
	case strings.HasPrefix(moduleID, "terraform-"):
		return "tld-terraform"
	case strings.HasPrefix(moduleID, "git-"):
		return "tld-git"
	default:
		if moduleID != "" {
			return "tld-linux"
		}
		return "ubuntu-24.04-standard"
	}
}

// ResolveInstanceSpec computes the runtime instance configuration for a lab container.
func ResolveInstanceSpec(moduleID, labID string, envSpec *EnvironmentSpec) *runtime.InstanceSpec {
	profileName := AutoDetectProfile(moduleID)
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
		InstanceID:         instanceID,
		Image:              profile.BaseImage,
		RequiresSystemd:    profile.RequiresSystemd,
		RequiresPrivileged: profile.RequiresSystemd,
		Capabilities:       caps,
		Ports:              ports,
		WorkspaceDir:       "/workspace",
	}
}

// GetProfilesForModules returns a deduplicated list of base images required by the given modules.
func GetProfilesForModules(moduleIDs []string) []string {
	seen := make(map[string]bool)
	var images []string
	for _, m := range moduleIDs {
		pName := AutoDetectProfile(m)
		prof := GetProfile(pName)
		if prof != nil && prof.BaseImage != "" && !seen[prof.BaseImage] {
			seen[prof.BaseImage] = true
			images = append(images, prof.BaseImage)
		}
	}
	return images
}
