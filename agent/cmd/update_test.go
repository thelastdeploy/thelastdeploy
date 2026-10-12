// cmd/update_test.go
package cmd

import (
	"os"
	"testing"
)

func TestParseChecksum(t *testing.T) {
	content := `# SHA256 Checksums
9b9a94879f744e1ed46b55aa66665d31cad0dc8b9fd9e351bd01d006965bc33c  tld-linux-amd64
ce06deacd553399f7162dd07e8d71dc201c0a10dd715821748dfa7369e7b2ae1  tld-linux-arm64
43ef60f45df326084b25b9a62c51334d029a22a24500f2e433123e959c3145ee  tld-darwin-amd64
65934e32b6341f606c26e31e5e09dfc7b9a1d7cf3f08c9cc1f20ed8cb853cb21  tld-darwin-arm64
`

	tests := []struct {
		binary   string
		expected string
		wantErr  bool
	}{
		{
			binary:   "tld-linux-amd64",
			expected: "9b9a94879f744e1ed46b55aa66665d31cad0dc8b9fd9e351bd01d006965bc33c",
			wantErr:  false,
		},
		{
			binary:   "tld-darwin-arm64",
			expected: "65934e32b6341f606c26e31e5e09dfc7b9a1d7cf3f08c9cc1f20ed8cb853cb21",
			wantErr:  false,
		},
		{
			binary:   "tld-windows-amd64",
			expected: "",
			wantErr:  true,
		},
	}

	for _, tt := range tests {
		hash, err := parseChecksum(content, tt.binary)
		if tt.wantErr && err == nil {
			t.Errorf("expected error for %s, got nil", tt.binary)
		}
		if !tt.wantErr && err != nil {
			t.Errorf("unexpected error for %s: %v", tt.binary, err)
		}
		if hash != tt.expected {
			t.Errorf("for %s expected %s, got %s", tt.binary, tt.expected, hash)
		}
	}
}

func TestFindAssetURL(t *testing.T) {
	release := &githubRelease{
		TagName: "v1.1.2",
		Assets: []struct {
			Name               string `json:"name"`
			BrowserDownloadURL string `json:"browser_download_url"`
			Size               int64  `json:"size"`
		}{
			{
				Name:               "checksums.txt",
				BrowserDownloadURL: "https://example.com/checksums.txt",
				Size:               120,
			},
			{
				Name:               "tld-linux-amd64",
				BrowserDownloadURL: "https://example.com/tld-linux-amd64",
				Size:               5000000,
			},
		},
	}

	url, err := findAssetURL(release, "tld-linux-amd64")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if url != "https://example.com/tld-linux-amd64" {
		t.Errorf("unexpected url: %s", url)
	}

	_, err = findAssetURL(release, "tld-nonexistent")
	if err == nil {
		t.Error("expected error for nonexistent asset, got nil")
	}
}

func TestCheckWritePermission(t *testing.T) {
	tempDir, err := os.MkdirTemp("", "tld-perm-test")
	if err != nil {
		t.Fatalf("failed to create temp dir: %v", err)
	}
	defer os.RemoveAll(tempDir)

	if err := checkWritePermission(tempDir); err != nil {
		t.Errorf("expected temp dir to be writable, got error: %v", err)
	}
}
