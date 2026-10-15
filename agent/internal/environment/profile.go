// agent/internal/environment/profile.go
package environment

type Profile struct {
	Name               string
	BaseImage          string
	RequiresSystemd    bool
	RequiresPrivileged bool
	DefaultPackages    []string
}

const DefaultProfile = "tld-ubuntu"

var Profiles = map[string]*Profile{
	// Clean Ubuntu sandbox with systemd, sudo, curl, python3
	"tld-ubuntu": {
		Name:               "tld-ubuntu",
		BaseImage:          "ghcr.io/thelastdeploy/tld-ubuntu:latest",
		RequiresSystemd:    true,
		RequiresPrivileged: false,
	},
	// Docker daemon sandbox (only used when explicitly specified by labs requiring a running docker daemon)
	"tld-dind": {
		Name:               "tld-dind",
		BaseImage:          "ghcr.io/thelastdeploy/tld-dind:latest",
		RequiresSystemd:    true,
		RequiresPrivileged: true,
	},
	// Kubernetes sandbox (only used when explicitly specified by labs requiring a running cluster)
	"tld-kind": {
		Name:               "tld-kind",
		BaseImage:          "ghcr.io/thelastdeploy/tld-kind:latest",
		RequiresSystemd:    true,
		RequiresPrivileged: true,
	},
}

func GetProfile(name string) *Profile {
	if p, ok := Profiles[name]; ok {
		return p
	}
	// Default fallback to clean ubuntu sandbox
	return Profiles[DefaultProfile]
}
