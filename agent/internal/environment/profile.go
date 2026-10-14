// agent/internal/environment/profile.go
package environment

type Profile struct {
	Name            string
	BaseImage       string
	RequiresSystemd bool
	DefaultPackages []string
}

var Profiles = map[string]*Profile{
	// Legacy fallback profiles
	"ubuntu-24.04-standard": {
		Name:            "ubuntu-24.04-standard",
		BaseImage:       "ubuntu:24.04",
		RequiresSystemd: false,
		DefaultPackages: []string{"bash", "coreutils", "curl", "python3", "git", "sudo"},
	},
	"ubuntu-24.04-systemd": {
		Name:            "ubuntu-24.04-systemd",
		BaseImage:       "ubuntu:24.04",
		RequiresSystemd: true,
		DefaultPackages: []string{"systemd", "systemd-sysv", "dbus", "cron", "logrotate", "rsyslog", "bash", "python3", "curl", "sudo"},
	},

	// Track-level specialized profiles (baked images with zero runtime apt-get delays)
	"tld-linux": {
		Name:            "tld-linux",
		BaseImage:       "ghcr.io/thelastdeploy/linux-base:latest",
		RequiresSystemd: true,
	},
	"tld-nginx": {
		Name:            "tld-nginx",
		BaseImage:       "ghcr.io/thelastdeploy/nginx-base:latest",
		RequiresSystemd: true,
	},
	"tld-docker": {
		Name:            "tld-docker",
		BaseImage:       "ghcr.io/thelastdeploy/docker-dind:latest",
		RequiresSystemd: true,
	},
	"tld-git": {
		Name:            "tld-git",
		BaseImage:       "ghcr.io/thelastdeploy/git-base:latest",
		RequiresSystemd: false,
	},
	"tld-terraform": {
		Name:            "tld-terraform",
		BaseImage:       "ghcr.io/thelastdeploy/terraform-base:latest",
		RequiresSystemd: false,
	},
	"tld-k8s": {
		Name:            "tld-k8s",
		BaseImage:       "ghcr.io/thelastdeploy/k8s-base:latest",
		RequiresSystemd: true,
	},
}

func GetProfile(name string) *Profile {
	if p, ok := Profiles[name]; ok {
		return p
	}
	// Default fallback profile for legacy labs
	return Profiles["ubuntu-24.04-standard"]
}
