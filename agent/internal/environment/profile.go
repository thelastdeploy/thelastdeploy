// agent/internal/environment/profile.go
package environment

type Profile struct {
	Name            string
	BaseImage       string
	RequiresSystemd bool
	DefaultPackages []string
}

var Profiles = map[string]*Profile{
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
}

func GetProfile(name string) *Profile {
	if p, ok := Profiles[name]; ok {
		return p
	}
	// Default fallback profile for legacy labs
	return Profiles["ubuntu-24.04-standard"]
}
