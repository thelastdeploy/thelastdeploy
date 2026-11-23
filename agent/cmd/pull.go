// cmd/pull.go
package cmd

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/thelastdeploy/agent/internal/config"
)

type LabExportItem struct {
	ID                 string   `json:"id"`
	Title              string   `json:"title"`
	Order              int      `json:"order"`
	EstimatedMinutes   *int     `json:"estimated_minutes"`
	EnvironmentProfile string   `json:"environment_profile"`
	SeedCommands       []string `json:"seed_commands"`
	ValidatorScript    *string  `json:"validator_script"`
	CleanupScript      *string  `json:"cleanup_script"`
	RawLabYAML         *string  `json:"raw_lab_yaml"`
	IsPythonValidator  bool     `json:"is_python_validator"`
	ContentHash        string   `json:"content_hash"`
}

type SectionExportItem struct {
	ID             string          `json:"id"`
	Title          string          `json:"title"`
	Order          int             `json:"order"`
	Content        *string         `json:"content"`
	RawSectionYAML *string         `json:"raw_section_yaml"`
	ContentHash    string          `json:"content_hash"`
	Labs           []LabExportItem `json:"labs"`
}

type ModuleExportResponse struct {
	ID               string              `json:"id"`
	Title            string              `json:"title"`
	Description      *string             `json:"description"`
	Topic            string              `json:"topic"`
	Difficulty       string              `json:"difficulty"`
	EstimatedMinutes *int                `json:"estimated_minutes"`
	RawModuleYAML    *string             `json:"raw_module_yaml"`
	ContentHash      string              `json:"content_hash"`
	Sections         []SectionExportItem `json:"sections"`
}

type BaselineSectionInfo struct {
	OriginalID   string `json:"original_id"`
	BaselineHash string `json:"baseline_hash"`
	Path         string `json:"path"`
}

type BaselineLabInfo struct {
	OriginalID   string `json:"original_id"`
	BaselineHash string `json:"baseline_hash"`
	SectionID    string `json:"section_id"`
	Path         string `json:"path"`
}

type TLDBaseline struct {
	OriginalModuleID   string                         `json:"original_module_id"`
	BaselineModuleHash string                         `json:"baseline_module_hash"`
	Sections           map[string]BaselineSectionInfo `json:"sections"`
	Labs               map[string]BaselineLabInfo     `json:"labs"`
}

func runPull(args []string) error {
	if os.Getenv("TLD_IN_CONTAINER") == "1" {
		fmt.Println("ℹ️  Module pulling is managed on your host machine.")
		fmt.Println("   Please run 'tld pull' from your host terminal.")
		return nil
	}

	if len(args) < 1 {
		return fmt.Errorf("missing module id. Usage: tld pull <module-id>")
	}
	moduleID := strings.TrimSpace(args[0])

	cfg, err := config.Load()
	if err != nil {
		return fmt.Errorf("load config: %w", err)
	}

	if cfg.AuthToken == "" {
		return fmt.Errorf("you must be logged in to pull. Run 'tld login' first")
	}

	fmt.Printf("Fetching official verified curriculum module: %s ...\n", moduleID)

	client := &http.Client{Timeout: 30 * time.Second}
	url := fmt.Sprintf("%s/modules/%s/export", cfg.APIBaseURL, moduleID)
	req, err := http.NewRequest(http.MethodGet, url, nil)
	if err != nil {
		return err
	}
	req.Header.Set("Authorization", "Bearer "+cfg.AuthToken)
	if cfg.ActiveOrg != "" {
		req.Header.Set("X-Organization-Slug", cfg.ActiveOrg)
		req.Header.Set("X-Organization", cfg.ActiveOrg)
	}

	resp, err := client.Do(req)
	if err != nil {
		return fmt.Errorf("network request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		bodyBytes, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("failed to pull module (status %d): %s", resp.StatusCode, string(bodyBytes))
	}

	var modExport ModuleExportResponse
	if err := json.NewDecoder(resp.Body).Decode(&modExport); err != nil {
		return fmt.Errorf("decode module export: %w", err)
	}

	destDir := filepath.Join(".", modExport.ID)
	if err := os.MkdirAll(destDir, 0755); err != nil {
		return fmt.Errorf("create destination directory: %w", err)
	}

	// 1. Write module.yaml
	moduleYAMLPath := filepath.Join(destDir, "module.yaml")
	modYAML := ""
	if modExport.RawModuleYAML != nil && *modExport.RawModuleYAML != "" {
		modYAML = *modExport.RawModuleYAML
	} else {
		desc := ""
		if modExport.Description != nil {
			desc = *modExport.Description
		}
		estMin := 30
		if modExport.EstimatedMinutes != nil {
			estMin = *modExport.EstimatedMinutes
		}
		modYAML = fmt.Sprintf("id: %s\ntitle: %q\ndescription: %q\ntopic: %s\ndifficulty: %s\nestimated_minutes: %d\n",
			modExport.ID, modExport.Title, desc, modExport.Topic, modExport.Difficulty, estMin)
	}
	if err := os.WriteFile(moduleYAMLPath, []byte(modYAML), 0644); err != nil {
		return fmt.Errorf("write module.yaml: %w", err)
	}

	baseline := TLDBaseline{
		OriginalModuleID:   modExport.ID,
		BaselineModuleHash: modExport.ContentHash,
		Sections:           make(map[string]BaselineSectionInfo),
		Labs:               make(map[string]BaselineLabInfo),
	}

	sectionsBaseDir := filepath.Join(destDir, "sections")
	if err := os.MkdirAll(sectionsBaseDir, 0755); err != nil {
		return fmt.Errorf("create sections directory: %w", err)
	}

	// 2. Unpack Sections and Labs
	for _, sec := range modExport.Sections {
		secFolderName := sec.ID
		if !strings.HasPrefix(secFolderName, fmt.Sprintf("%02d-", sec.Order)) &&
			!strings.HasPrefix(secFolderName, fmt.Sprintf("%d-", sec.Order)) {
			secFolderName = fmt.Sprintf("%02d-%s", sec.Order, sec.ID)
		}

		secDir := filepath.Join(sectionsBaseDir, secFolderName)
		if err := os.MkdirAll(secDir, 0755); err != nil {
			return fmt.Errorf("create section directory %s: %w", secFolderName, err)
		}

		secYAMLPath := filepath.Join(secDir, "section.yaml")
		secYAML := ""
		if sec.RawSectionYAML != nil && *sec.RawSectionYAML != "" {
			secYAML = *sec.RawSectionYAML
		} else {
			secYAML = fmt.Sprintf("id: %s\ntitle: %q\norder: %d\n", sec.ID, sec.Title, sec.Order)
		}
		if err := os.WriteFile(secYAMLPath, []byte(secYAML), 0644); err != nil {
			return fmt.Errorf("write section.yaml: %w", err)
		}

		if sec.Content != nil {
			contentMDPath := filepath.Join(secDir, "content.md")
			if err := os.WriteFile(contentMDPath, []byte(*sec.Content), 0644); err != nil {
				return fmt.Errorf("write content.md: %w", err)
			}
		}

		baseline.Sections[sec.ID] = BaselineSectionInfo{
			OriginalID:   sec.ID,
			BaselineHash: sec.ContentHash,
			Path:         filepath.Join("sections", secFolderName),
		}

		labsBaseDir := filepath.Join(secDir, "labs")
		if len(sec.Labs) > 0 {
			if err := os.MkdirAll(labsBaseDir, 0755); err != nil {
				return fmt.Errorf("create labs directory: %w", err)
			}
		}

		for _, lab := range sec.Labs {
			labDir := filepath.Join(labsBaseDir, lab.ID)
			if err := os.MkdirAll(labDir, 0755); err != nil {
				return fmt.Errorf("create lab directory %s: %w", lab.ID, err)
			}

			labYAMLPath := filepath.Join(labDir, "lab.yaml")
			labYAML := ""
			if lab.RawLabYAML != nil && *lab.RawLabYAML != "" {
				labYAML = *lab.RawLabYAML
			} else {
				estMin := 10
				if lab.EstimatedMinutes != nil {
					estMin = *lab.EstimatedMinutes
				}
				profile := "tld-ubuntu"
				if lab.EnvironmentProfile != "" {
					profile = lab.EnvironmentProfile
				}
				seedLines := ""
				if len(lab.SeedCommands) > 0 {
					seedLines = "\nseed_commands:\n"
					for _, cmd := range lab.SeedCommands {
						seedLines += fmt.Sprintf("  - %q\n", cmd)
					}
				}
				labYAML = fmt.Sprintf("id: %s\ntitle: %q\norder: %d\nestimated_minutes: %d\nenvironment:\n  profile: %s%s\n",
					lab.ID, lab.Title, lab.Order, estMin, profile, seedLines)
			}
			if err := os.WriteFile(labYAMLPath, []byte(labYAML), 0644); err != nil {
				return fmt.Errorf("write lab.yaml: %w", err)
			}

			if lab.CleanupScript != nil && *lab.CleanupScript != "" {
				cleanupPath := filepath.Join(labDir, "cleanup.sh")
				if err := os.WriteFile(cleanupPath, []byte(*lab.CleanupScript), 0755); err != nil {
					return fmt.Errorf("write cleanup.sh: %w", err)
				}
			}

			if lab.ValidatorScript != nil && *lab.ValidatorScript != "" {
				valFileName := "validator.sh"
				if lab.IsPythonValidator {
					valFileName = "validator.py"
				}
				valPath := filepath.Join(labDir, valFileName)
				if err := os.WriteFile(valPath, []byte(*lab.ValidatorScript), 0755); err != nil {
					return fmt.Errorf("write validator script: %w", err)
				}
			}

			baseline.Labs[lab.ID] = BaselineLabInfo{
				OriginalID:   lab.ID,
				BaselineHash: lab.ContentHash,
				SectionID:    sec.ID,
				Path:         filepath.Join("sections", secFolderName, "labs", lab.ID),
			}
		}
	}

	// 3. Write .tld-baseline.json
	baselineBytes, err := json.MarshalIndent(baseline, "", "  ")
	if err != nil {
		return fmt.Errorf("serialize baseline metadata: %w", err)
	}
	baselineFilePath := filepath.Join(destDir, ".tld-baseline.json")
	if err := os.WriteFile(baselineFilePath, baselineBytes, 0644); err != nil {
		return fmt.Errorf("write .tld-baseline.json: %w", err)
	}

	fmt.Printf("\n\x1b[32m✓ Successfully pulled module '%s' into %s\x1b[0m\n", modExport.ID, destDir)
	fmt.Printf("Sections: %d | Total Labs: %d\n", len(modExport.Sections), len(baseline.Labs))
	fmt.Println("Baseline content hashes recorded in .tld-baseline.json.")
	fmt.Printf("To customize, edit the files in %s and run:\n", destDir)
	fmt.Printf("  tld publish %s\n", destDir)

	return nil
}
