// cmd/update.go
package cmd

import (
	"bufio"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"time"
)

const (
	githubRepoOwner = "thelastdeploy"
	githubRepoName  = "thelastdeploy"
	githubAPIBase   = "https://api.github.com"
)

type githubRelease struct {
	TagName    string `json:"tag_name"`
	Name       string `json:"name"`
	Body       string `json:"body"`
	Prerelease bool   `json:"prerelease"`
	Assets     []struct {
		Name               string `json:"name"`
		BrowserDownloadURL string `json:"browser_download_url"`
		Size               int64  `json:"size"`
	} `json:"assets"`
}

func runUpdate(args []string) error {
	fs := flag.NewFlagSet("update", flag.ContinueOnError)
	fs.Usage = func() {
		fmt.Printf(`Usage:
  tld update [options]

Update the TLD CLI binary to the latest release or bleeding edge build.

Options:
  --check          Check for available updates without installing
  --edge, --latest Update to the bleeding edge rolling build from main
  --force          Force re-download even if already up to date
  --version <tag>  Target a specific release version (e.g. v1.1.2)
  --help, -h       Show this help message
`)
	}
	edgeFlag := fs.Bool("edge", false, "Update to the bleeding edge rolling build from main")
	latestFlag := fs.Bool("latest", false, "Alias for --edge")
	checkFlag := fs.Bool("check", false, "Check for available updates without downloading or installing")
	forceFlag := fs.Bool("force", false, "Force re-download even if already on the requested version")
	versionFlag := fs.String("version", "", "Target a specific release version tag (e.g. v1.1.2)")

	if err := fs.Parse(args); err != nil {
		if errors.Is(err, flag.ErrHelp) {
			return nil
		}
		return err
	}

	useEdge := *edgeFlag || *latestFlag
	targetTag := "stable"
	channelName := "stable"

	if *versionFlag != "" {
		targetTag = *versionFlag
		channelName = *versionFlag
	} else if useEdge {
		targetTag = "latest"
		channelName = "edge (bleeding)"
	}

	// Validate OS and Architecture
	goos := runtime.GOOS
	goarch := runtime.GOARCH
	if (goos != "linux" && goos != "darwin") || (goarch != "amd64" && goarch != "arm64") {
		return fmt.Errorf("unsupported platform: %s/%s (only linux/darwin amd64/arm64 are officially supported)", goos, goarch)
	}
	binaryName := fmt.Sprintf("tld-%s-%s", goos, goarch)

	// Identify currently running executable path
	execPath, err := os.Executable()
	if err != nil {
		return fmt.Errorf("failed to locate running executable: %w", err)
	}
	realExecPath, err := filepath.EvalSymlinks(execPath)
	if err != nil {
		realExecPath = execPath
	}
	targetDir := filepath.Dir(realExecPath)

	fmt.Printf("\x1b[1;36m==> Checking for TLD CLI updates...\x1b[0m\n")
	fmt.Printf("    Current Version : \x1b[1m%s\x1b[0m\n", Version)
	fmt.Printf("    Target Channel  : \x1b[1m%s\x1b[0m\n", channelName)
	fmt.Printf("    Platform        : %s/%s\n", goos, goarch)
	fmt.Printf("    Binary Location : %s\n\n", realExecPath)

	// Fetch release information from GitHub API
	client := &http.Client{Timeout: 30 * time.Second}
	release, err := fetchRelease(client, targetTag)
	if err != nil {
		return fmt.Errorf("failed to fetch release information: %w", err)
	}

	remoteVersion := release.TagName
	if remoteVersion == "" {
		remoteVersion = targetTag
	}

	// Check if already on this version
	isSameVersion := strings.TrimPrefix(Version, "v") == strings.TrimPrefix(remoteVersion, "v")
	if Version == remoteVersion || isSameVersion {
		if !useEdge && !*forceFlag {
			fmt.Printf("✓ You are already on the requested version (\x1b[1;32m%s\x1b[0m).\n", Version)
			if *checkFlag {
				return nil
			}
			fmt.Println("Use \x1b[1mtld update --force\x1b[0m to reinstall or \x1b[1mtld update --edge\x1b[0m for bleeding-edge.")
			return nil
		}
	}

	if *checkFlag {
		fmt.Printf("🚀 Update available: \x1b[1;32m%s\x1b[0m → \x1b[1;32m%s\x1b[0m\n", Version, remoteVersion)
		if release.Name != "" && release.Name != release.TagName {
			fmt.Printf("   Release: %s\n", release.Name)
		}
		fmt.Println("\nRun \x1b[1mtld update\x1b[0m to install the update.")
		return nil
	}

	// Check write permissions on target directory
	if err := checkWritePermission(targetDir); err != nil {
		var flagStr string
		if useEdge {
			flagStr = " --edge"
		} else if *versionFlag != "" {
			flagStr = " --version " + *versionFlag
		}
		return fmt.Errorf("🔒 Permission denied writing to %s\nPlease run with elevated privileges:\n  sudo tld update%s", targetDir, flagStr)
	}

	// Find download URLs for binary and checksums
	binaryURL, err := findAssetURL(release, binaryName)
	if err != nil {
		// Fallback to standard release download URL format
		binaryURL = fmt.Sprintf("https://github.com/%s/%s/releases/download/%s/%s",
			githubRepoOwner, githubRepoName, targetTag, binaryName)
	}

	checksumURL, err := findAssetURL(release, "checksums.txt")
	if err != nil {
		checksumURL = fmt.Sprintf("https://github.com/%s/%s/releases/download/%s/checksums.txt",
			githubRepoOwner, githubRepoName, targetTag)
	}

	// Download and parse checksums
	fmt.Printf("==> Fetching checksums from %s...\n", checksumURL)
	expectedHash, err := fetchExpectedChecksum(client, checksumURL, binaryName)
	if err != nil {
		fmt.Printf("⚠️  Warning: Could not verify checksum (%v). Proceeding with caution...\n", err)
	}

	// Download binary to a temporary file in the target directory (ensuring atomic rename)
	fmt.Printf("==> Downloading \x1b[1m%s\x1b[0m (%s)...\n", binaryName, targetTag)
	tempFile, err := os.CreateTemp(targetDir, ".tld-update-*")
	if err != nil {
		return fmt.Errorf("failed to create temporary update file in %s: %w", targetDir, err)
	}
	tempPath := tempFile.Name()
	defer func() {
		// Clean up temporary file if it still exists
		if _, err := os.Stat(tempPath); err == nil {
			_ = os.Remove(tempPath)
		}
	}()

	hasher := sha256.New()
	mw := io.MultiWriter(tempFile, hasher)

	downloadClient := &http.Client{Timeout: 5 * time.Minute}
	req, err := http.NewRequest("GET", binaryURL, nil)
	if err != nil {
		_ = tempFile.Close()
		return fmt.Errorf("failed to create download request: %w", err)
	}
	req.Header.Set("User-Agent", "tld-cli/"+Version)

	resp, err := downloadClient.Do(req)
	if err != nil {
		_ = tempFile.Close()
		return fmt.Errorf("download failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		_ = tempFile.Close()
		return fmt.Errorf("download failed with HTTP %d from %s", resp.StatusCode, binaryURL)
	}

	written, err := io.Copy(mw, resp.Body)
	if err != nil {
		_ = tempFile.Close()
		return fmt.Errorf("failed to save downloaded binary: %w", err)
	}
	_ = tempFile.Close()

	fmt.Printf("    Downloaded %.2f MB\n", float64(written)/(1024*1024))

	// Verify checksum if available
	if expectedHash != "" {
		actualHash := hex.EncodeToString(hasher.Sum(nil))
		if !strings.EqualFold(expectedHash, actualHash) {
			return fmt.Errorf("checksum verification failed!\n  Expected: %s\n  Actual:   %s", expectedHash, actualHash)
		}
		fmt.Printf("✓ Checksum verified (SHA-256)\n")
	}

	// Set executable permissions
	if err := os.Chmod(tempPath, 0755); err != nil {
		return fmt.Errorf("failed to make binary executable: %w", err)
	}

	// Atomically replace existing binary
	fmt.Printf("==> Applying update to %s...\n", realExecPath)
	if err := os.Rename(tempPath, realExecPath); err != nil {
		return fmt.Errorf("failed to replace binary %s: %w", realExecPath, err)
	}

	fmt.Printf("\n\x1b[1;32m✓ Successfully updated TLD CLI!\x1b[0m\n")
	fmt.Printf("  New version: \x1b[1m%s\x1b[0m\n", remoteVersion)
	fmt.Printf("  Binary path: %s\n", realExecPath)
	return nil
}

func fetchRelease(client *http.Client, tag string) (*githubRelease, error) {
	var url string
	if tag == "stable" {
		url = fmt.Sprintf("%s/repos/%s/%s/releases/latest", githubAPIBase, githubRepoOwner, githubRepoName)
	} else {
		url = fmt.Sprintf("%s/repos/%s/%s/releases/tags/%s", githubAPIBase, githubRepoOwner, githubRepoName, tag)
	}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("User-Agent", "tld-cli/"+Version)
	req.Header.Set("Accept", "application/vnd.github.v3+json")

	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusNotFound && tag == "stable" {
		// Fallback to tags/stable if /releases/latest returns 404
		url = fmt.Sprintf("%s/repos/%s/%s/releases/tags/stable", githubAPIBase, githubRepoOwner, githubRepoName)
		req2, _ := http.NewRequest("GET", url, nil)
		req2.Header.Set("User-Agent", "tld-cli/"+Version)
		resp2, err2 := client.Do(req2)
		if err2 == nil && resp2.StatusCode == http.StatusOK {
			defer resp2.Body.Close()
			var r githubRelease
			if err := json.NewDecoder(resp2.Body).Decode(&r); err == nil {
				return &r, nil
			}
		}
	}

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("GitHub API returned status %d for %s", resp.StatusCode, url)
	}

	var rel githubRelease
	if err := json.NewDecoder(resp.Body).Decode(&rel); err != nil {
		return nil, err
	}
	return &rel, nil
}

func findAssetURL(release *githubRelease, assetName string) (string, error) {
	for _, a := range release.Assets {
		if a.Name == assetName {
			return a.BrowserDownloadURL, nil
		}
	}
	return "", fmt.Errorf("asset %s not found in release %s", assetName, release.TagName)
}

func fetchExpectedChecksum(client *http.Client, checksumURL string, targetBinary string) (string, error) {
	req, err := http.NewRequest("GET", checksumURL, nil)
	if err != nil {
		return "", err
	}
	req.Header.Set("User-Agent", "tld-cli/"+Version)

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("checksum file returned HTTP %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	return parseChecksum(string(body), targetBinary)
}

func parseChecksum(content string, targetBinary string) (string, error) {
	scanner := bufio.NewScanner(strings.NewReader(content))
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		fields := strings.Fields(line)
		if len(fields) >= 2 {
			hash := fields[0]
			name := filepath.Base(fields[1])
			if name == targetBinary {
				return hash, nil
			}
		}
	}
	return "", errors.New("binary checksum not found in checksums.txt")
}

func checkWritePermission(dir string) error {
	testFile := filepath.Join(dir, fmt.Sprintf(".tld-perm-test-%d", os.Getpid()))
	f, err := os.OpenFile(testFile, os.O_WRONLY|os.O_CREATE|os.O_EXCL, 0644)
	if err != nil {
		return err
	}
	_ = f.Close()
	_ = os.Remove(testFile)
	return nil
}
