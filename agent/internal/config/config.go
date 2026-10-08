// internal/config/config.go
package config

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

type Config struct {
	APIBaseURL     string
	DeviceKeyPath  string
	ChallengesDir  string
	AuthToken      string
	Username       string
	ChallengesRepo string
	Environment    string // "production" or "local"
}

var (
	// DefaultAPIBaseURL is the fallback API base URL. Can be overridden via -ldflags.
	DefaultAPIBaseURL = "https://api.thelastdeploy.com"
	// DefaultConfigDirName is the directory name in user home dir. Can be overridden via -ldflags.
	DefaultConfigDirName = ".tld"
	// BuildEnvironment is the build environment name ("production" or "local"). Can be overridden via -ldflags.
	BuildEnvironment = "production"
)

const defaultChallengesRepo = "thelastdeploy/thelastdeploy"

func IsDevEnv(cfg *Config) bool {
	if cfg == nil {
		return false
	}
	return cfg.Environment == "local" || cfg.Environment == "dev" || strings.Contains(cfg.APIBaseURL, "localhost") || strings.Contains(cfg.APIBaseURL, "127.0.0.1")
}

func getEnvMode() string {
	if env := strings.ToLower(os.Getenv("TLD_ENV")); env != "" {
		if env == "local" || env == "dev" || env == "development" {
			return "local"
		}
		return env
	}
	if strings.ToLower(BuildEnvironment) == "local" || strings.ToLower(BuildEnvironment) == "dev" {
		return "local"
	}
	return "production"
}

func Load() (*Config, error) {
	path, err := configPath()
	if err != nil {
		return nil, err
	}
	if err := os.MkdirAll(filepath.Dir(path), 0700); err != nil {
		return nil, fmt.Errorf("create config dir: %w", err)
	}
	data, err := os.ReadFile(path)
	if err == nil {
		return parse(string(data)), nil
	}
	if !os.IsNotExist(err) {
		return nil, fmt.Errorf("read config: %w", err)
	}
	cfg := defaults()
	if err := write(path, cfg); err != nil {
		return nil, fmt.Errorf("write default config: %w", err)
	}
	return cfg, nil
}

func Save(cfg *Config) error {
	path, err := configPath()
	if err != nil {
		return err
	}
	return write(path, cfg)
}

func TLDDir() (string, error) {
	if customDir := os.Getenv("TLD_DIR"); customDir != "" {
		return expandHome(customDir), nil
	}

	mode := getEnvMode()
	dirName := DefaultConfigDirName
	if mode == "local" && dirName == ".tld" {
		dirName = ".tld-dev"
	}

	home, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(home, dirName), nil
}

func configPath() (string, error) {
	dir, err := TLDDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(dir, "config.yaml"), nil
}

func defaults() *Config {
	dir, _ := TLDDir()
	mode := getEnvMode()

	baseURL := DefaultAPIBaseURL
	if mode == "local" && baseURL == "https://api.thelastdeploy.com" {
		baseURL = "http://localhost:9001"
	}
	if override := os.Getenv("TLD_API_URL"); override != "" {
		baseURL = override
	}

	return &Config{
		APIBaseURL:     baseURL,
		DeviceKeyPath:  filepath.Join(dir, "device.key"),
		ChallengesDir:  filepath.Join(dir, "challenges"),
		ChallengesRepo: defaultChallengesRepo,
		Environment:    mode,
	}
}

func parse(raw string) *Config {
	cfg := defaults()
	for _, line := range strings.Split(raw, "\n") {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		idx := strings.Index(line, ":")
		if idx == -1 {
			continue
		}
		key := strings.TrimSpace(line[:idx])
		val := strings.Trim(strings.TrimSpace(line[idx+1:]), `"'`)
		switch key {
		case "api_base_url":
			if val != "" {
				cfg.APIBaseURL = val
			}
		case "device_key_path":
			if val != "" {
				cfg.DeviceKeyPath = expandHome(val)
			}
		case "challenges_dir":
			if val != "" {
				cfg.ChallengesDir = expandHome(val)
			}
		case "challenges_repo":
			if val != "" {
				cfg.ChallengesRepo = val
			}
		case "auth_token":
			cfg.AuthToken = val
		case "username":
			cfg.Username = val
		case "environment":
			if val != "" {
				cfg.Environment = val
			}
		}
	}

	// Environment variable overrides ALWAYS take precedence
	mode := getEnvMode()
	if mode == "local" {
		cfg.Environment = "local"
		if cfg.APIBaseURL == "https://api.thelastdeploy.com" {
			cfg.APIBaseURL = "http://localhost:9001"
		}
	}
	if override := os.Getenv("TLD_API_URL"); override != "" {
		cfg.APIBaseURL = override
	}

	return cfg
}

func write(path string, cfg *Config) error {
	authLine := ""
	if cfg.AuthToken != "" {
		authLine = fmt.Sprintf("auth_token: %s\n", strings.TrimSpace(cfg.AuthToken))
	}
	userLine := ""
	if cfg.Username != "" {
		userLine = fmt.Sprintf("username: %s\n", strings.TrimSpace(cfg.Username))
	}
	content := fmt.Sprintf("# The Last Deploy — agent configuration\n# Generated automatically on first run. Safe to edit.\nenvironment: %s\napi_base_url: %s\ndevice_key_path: %s\nchallenges_dir: %s\nchallenges_repo: %s\n%s%s",
		cfg.Environment, cfg.APIBaseURL, cfg.DeviceKeyPath, cfg.ChallengesDir, cfg.ChallengesRepo, authLine, userLine)
	return os.WriteFile(path, []byte(content), 0600)
}

func expandHome(p string) string {
	if !strings.HasPrefix(p, "~/") {
		return p
	}
	home, err := os.UserHomeDir()
	if err != nil {
		return p
	}
	return filepath.Join(home, p[2:])
}
