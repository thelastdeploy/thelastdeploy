// cmd/publish.go
package cmd

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/thelastdeploy/agent/internal/config"
	"github.com/thelastdeploy/agent/internal/contenthash"
)

type BuilderLabInput struct {
	ID                 string   `json:"id"`
	Title              string   `json:"title"`
	Order              int      `json:"order"`
	XP                 int      `json:"xp"`
	EstimatedMinutes   *int     `json:"estimated_minutes"`
	EnvironmentProfile string   `json:"environment_profile"`
	SeedCommands       []string `json:"seed_commands"`
	ValidatorScript    *string  `json:"validator_script"`
	CleanupScript      *string  `json:"cleanup_script"`
	ContentHash        string   `json:"content_hash"`
	IsOrgOwned         bool     `json:"is_org_owned"`
	OriginalID         string   `json:"original_id,omitempty"`
}

type BuilderSectionInput struct {
	ID          string            `json:"id"`
	Title       string            `json:"title"`
	Order       int               `json:"order"`
	XP          int               `json:"xp"`
	Content     *string           `json:"content"`
	ContentHash string            `json:"content_hash"`
	IsOrgOwned  bool              `json:"is_org_owned"`
	OriginalID  string            `json:"original_id,omitempty"`
	Labs        []BuilderLabInput `json:"labs"`
}

type BuilderModuleInput struct {
	ID               string                `json:"id"`
	Title            string                `json:"title"`
	Description      *string               `json:"description"`
	Topic            string                `json:"topic"`
	Difficulty       string                `json:"difficulty"`
	EstimatedMinutes *int                  `json:"estimated_minutes"`
	ContentHash      string                `json:"content_hash"`
	IsOrgOwned       bool                  `json:"is_org_owned"`
	OriginalID       string                `json:"original_id,omitempty"`
	Sections         []BuilderSectionInput `json:"sections"`
}

func runPublish(args []string) error {
	if os.Getenv("TLD_IN_CONTAINER") == "1" {
		fmt.Println("ℹ️  Module publishing is managed on your host machine.")
		fmt.Println("   Please run 'tld publish' from your host terminal.")
		return nil
	}

	if len(args) < 1 {
		return fmt.Errorf("missing module folder path. Usage: tld publish <folder-path>")
	}
	folderPath := args[0]

	cfg, err := config.Load()
	if err != nil {
		return fmt.Errorf("load config: %w", err)
	}

	if cfg.AuthToken == "" {
		return fmt.Errorf("you must be logged in to publish. Run 'tld login' first")
	}

	fmt.Printf("Analyzing and preparing to publish module from folder: %s\n", folderPath)

	module, err := parseAndHashModuleDirectory(folderPath)
	if err != nil {
		return fmt.Errorf("parse folder structure: %w", err)
	}

	// Ensure proposed XP is defaulted if missing
	for i := range module.Sections {
		if module.Sections[i].XP == 0 {
			module.Sections[i].XP = 10
		}
		for j := range module.Sections[i].Labs {
			if module.Sections[i].Labs[j].XP == 0 {
				module.Sections[i].Labs[j].XP = 30
			}
		}
	}

	// Output summary of detected ownership and modifications
	fmt.Printf("\nContent Ownership & Publication Plan:\n")
	modOwner := "Custom/Org-owned"
	if !module.IsOrgOwned {
		modOwner = "TLD Core"
	}
	fmt.Printf("📦 Module: %s (%s, hash: %.8s...)\n", module.ID, modOwner, module.ContentHash)
	for _, sec := range module.Sections {
		secOwner := "Custom/Org-owned"
		if !sec.IsOrgOwned {
			secOwner = "TLD Core (inherited)"
		}
		fmt.Printf("  ├── Section: %s [%s] (hash: %.8s...)\n", sec.ID, secOwner, sec.ContentHash)
		for _, lab := range sec.Labs {
			labOwner := "Custom/Org-owned"
			if !lab.IsOrgOwned {
				labOwner = "TLD Core (inherited)"
			}
			fmt.Printf("  │   └── Lab: %s [%s] (hash: %.8s...)\n", lab.ID, labOwner, lab.ContentHash)
		}
	}
	fmt.Println()

	payload, err := json.Marshal(module)
	if err != nil {
		return fmt.Errorf("serialize module structure: %w", err)
	}

	client := &http.Client{Timeout: 30 * time.Second}
	req, err := http.NewRequest(http.MethodPost, cfg.APIBaseURL+"/builder/modules", bytes.NewReader(payload))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")
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

	bodyBytes, _ := io.ReadAll(resp.Body)
	if resp.StatusCode != http.StatusOK && resp.StatusCode != http.StatusCreated {
		return fmt.Errorf("server returned status %d: %s", resp.StatusCode, string(bodyBytes))
	}

	fmt.Printf("\x1b[32m✓ Module '%s' successfully published!\x1b[0m\n", module.ID)
	fmt.Println("Status: published (unverified, rewards 0 XP until approved).")
	fmt.Println("Unmodified TLD sections/labs will inherit future TLD updates automatically.")

	return nil
}

type yamlMap map[string]string

func readSimpleYAML(path string) (yamlMap, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}

	res := make(yamlMap)
	lines := strings.Split(string(data), "\n")
	for _, line := range lines {
		trimmed := strings.TrimSpace(line)
		if trimmed == "" || strings.HasPrefix(trimmed, "#") {
			continue
		}
		idx := strings.Index(trimmed, ":")
		if idx == -1 {
			continue
		}
		key := strings.TrimSpace(trimmed[:idx])
		val := strings.Trim(strings.TrimSpace(trimmed[idx+1:]), `"'`)
		res[key] = val
	}
	return res, nil
}

func parseAndHashModuleDirectory(root string) (*BuilderModuleInput, error) {
	// 1. Try reading .tld-baseline.json if present
	var baseline *TLDBaseline
	baselinePath := filepath.Join(root, ".tld-baseline.json")
	if baselineBytes, err := os.ReadFile(baselinePath); err == nil {
		var b TLDBaseline
		if err := json.Unmarshal(baselineBytes, &b); err == nil {
			baseline = &b
		}
	}

	modYamlPath := filepath.Join(root, "module.yaml")
	modRawBytes, err := os.ReadFile(modYamlPath)
	if err != nil {
		return nil, fmt.Errorf("read module.yaml: %w", err)
	}
	modData, err := readSimpleYAML(modYamlPath)
	if err != nil {
		return nil, fmt.Errorf("parse module.yaml: %w", err)
	}

	id := modData["id"]
	title := modData["title"]
	topic := modData["topic"]
	difficulty := modData["difficulty"]

	if id == "" || title == "" || topic == "" || difficulty == "" {
		return nil, fmt.Errorf("module.yaml is missing required fields (id, title, topic, difficulty)")
	}

	description := modData["description"]
	var estMin *int
	if minStr, ok := modData["estimated_minutes"]; ok {
		if val, err := strconv.Atoi(minStr); err == nil {
			estMin = &val
		}
	}

	// Module hash (SHA-256 over module.yaml)
	modHash := contenthash.ComputeModuleHash(modRawBytes)

	// Direct module modification check
	isModDirectlyModified := true
	origModID := ""
	if baseline != nil {
		origModID = baseline.OriginalModuleID
		if baseline.BaselineModuleHash != "" && baseline.BaselineModuleHash == modHash {
			isModDirectlyModified = false
		}
	}

	sectionsDir := filepath.Join(root, "sections")
	secEntries, err := os.ReadDir(sectionsDir)
	if err != nil {
		return nil, fmt.Errorf("read sections/ directory: %w", err)
	}

	sections := []BuilderSectionInput{}
	orderSec := 1
	anySectionOrgOwned := false

	for _, secEntry := range secEntries {
		if !secEntry.IsDir() {
			continue
		}
		secFolder := filepath.Join(sectionsDir, secEntry.Name())
		secYamlPath := filepath.Join(secFolder, "section.yaml")
		secRawBytes, err := os.ReadFile(secYamlPath)
		if os.IsNotExist(err) {
			continue
		} else if err != nil {
			return nil, fmt.Errorf("read section.yaml in %s: %w", secEntry.Name(), err)
		}

		secData, err := readSimpleYAML(secYamlPath)
		if err != nil {
			return nil, fmt.Errorf("read section.yaml in %s: %w", secEntry.Name(), err)
		}

		secID := secData["id"]
		secTitle := secData["title"]
		if secID == "" || secTitle == "" {
			return nil, fmt.Errorf("section.yaml in %s is missing required fields (id, title)", secEntry.Name())
		}

		// Read content.md
		var content *string
		var contentMDBytes []byte
		contentMdPath := filepath.Join(secFolder, "content.md")
		if mdBytes, err := os.ReadFile(contentMdPath); err == nil {
			contentMDBytes = mdBytes
			cStr := string(mdBytes)
			content = &cStr
		}

		// Section hash (SHA-256 over section.yaml and content.md)
		secHash := contenthash.ComputeSectionHash(secRawBytes, contentMDBytes)

		// Direct section modification check
		isSecDirectlyModified := true
		origSecID := ""
		if baseline != nil {
			if baseSec, ok := baseline.Sections[secID]; ok {
				origSecID = baseSec.OriginalID
				if baseSec.BaselineHash != "" && baseSec.BaselineHash == secHash {
					isSecDirectlyModified = false
				}
			}
		}

		// Read labs
		labsDir := filepath.Join(secFolder, "labs")
		labs := []BuilderLabInput{}
		anyLabInSecOrgOwned := false

		if _, err := os.Stat(labsDir); err == nil {
			labEntries, err := os.ReadDir(labsDir)
			if err == nil {
				orderLab := 1
				for _, labEntry := range labEntries {
					if !labEntry.IsDir() {
						continue
					}
					labFolder := filepath.Join(labsDir, labEntry.Name())
					labYamlPath := filepath.Join(labFolder, "lab.yaml")
					labRawBytes, err := os.ReadFile(labYamlPath)
					if os.IsNotExist(err) {
						continue
					} else if err != nil {
						return nil, fmt.Errorf("read lab.yaml in %s: %w", labEntry.Name(), err)
					}

					labData, err := readSimpleYAML(labYamlPath)
					if err != nil {
						return nil, fmt.Errorf("read lab.yaml in %s: %w", labEntry.Name(), err)
					}

					labID := labData["id"]
					labTitle := labData["title"]
					if labID == "" || labTitle == "" {
						return nil, fmt.Errorf("lab.yaml in %s is missing required fields (id, title)", labEntry.Name())
					}

					var labEstMin *int
					if labMinStr, ok := labData["estimated_minutes"]; ok {
						if val, err := strconv.Atoi(labMinStr); err == nil {
							labEstMin = &val
						}
					}

					profile := "tld-ubuntu"
					if p, ok := labData["profile"]; ok && p != "" {
						profile = p
					}

					// Parse seed_commands
					seedCmds := []string{}
					rawYaml := string(labRawBytes)
					lines := strings.Split(rawYaml, "\n")
					inSeedCmds := false
					for _, line := range lines {
						trimmed := strings.TrimSpace(line)
						if strings.HasPrefix(trimmed, "seed_commands:") {
							inSeedCmds = true
							continue
						}
						if inSeedCmds {
							if strings.Contains(trimmed, ":") && !strings.HasPrefix(trimmed, "-") {
								inSeedCmds = false
								continue
							}
							if strings.HasPrefix(trimmed, "-") {
								cmd := strings.Trim(strings.TrimSpace(trimmed[1:]), `"'`)
								if cmd != "" {
									seedCmds = append(seedCmds, cmd)
								}
							}
						}
					}

					// Read cleanup.sh
					var cleanupBytes []byte
					var cleanupScript *string
					cleanupPath := filepath.Join(labFolder, "cleanup.sh")
					if cBytes, err := os.ReadFile(cleanupPath); err == nil {
						cleanupBytes = cBytes
						cStr := string(cBytes)
						cleanupScript = &cStr
					}

					// Read validator script
					var valScript *string
					var valBytes []byte
					isPyVal := false
					valPath := filepath.Join(labFolder, "validator.sh")
					if _, err := os.Stat(valPath); os.IsNotExist(err) {
						valPath = filepath.Join(labFolder, "validator.py")
						isPyVal = true
					}
					if vBytes, err := os.ReadFile(valPath); err == nil {
						valBytes = vBytes
						vStr := string(vBytes)
						valScript = &vStr
					}

					// Lab hash (SHA-256 over lab.yaml, cleanup.sh, validator)
					labHash := contenthash.ComputeLabHash(labRawBytes, cleanupBytes, valBytes, isPyVal)

					// Direct lab modification check
					isLabDirectlyModified := true
					origLabID := ""
					if baseline != nil {
						if baseLab, ok := baseline.Labs[labID]; ok {
							origLabID = baseLab.OriginalID
							if baseLab.BaselineHash != "" && baseLab.BaselineHash == labHash {
								isLabDirectlyModified = false
							}
						}
					}

					if isLabDirectlyModified {
						anyLabInSecOrgOwned = true
					}

					labs = append(labs, BuilderLabInput{
						ID:                 labID,
						Title:              labTitle,
						Order:              orderLab,
						XP:                 0,
						EstimatedMinutes:   labEstMin,
						EnvironmentProfile: profile,
						SeedCommands:       seedCmds,
						ValidatorScript:    valScript,
						CleanupScript:      cleanupScript,
						ContentHash:        labHash,
						IsOrgOwned:         isLabDirectlyModified,
						OriginalID:         origLabID,
					})
					orderLab++
				}
			}
		}

		// UPWARD OWNERSHIP PROPAGATION:
		// If ANY lab in this section is org-owned, the section is org-owned!
		isSectionOrgOwned := isSecDirectlyModified || anyLabInSecOrgOwned
		if isSectionOrgOwned {
			anySectionOrgOwned = true
		}

		sections = append(sections, BuilderSectionInput{
			ID:          secID,
			Title:       secTitle,
			Order:       orderSec,
			XP:          0,
			Content:     content,
			ContentHash: secHash,
			IsOrgOwned:  isSectionOrgOwned,
			OriginalID:  origSecID,
			Labs:        labs,
		})
		orderSec++
	}

	// UPWARD OWNERSHIP PROPAGATION:
	// If ANY section in this module is org-owned, the module is org-owned!
	isModuleOrgOwned := isModDirectlyModified || anySectionOrgOwned

	return &BuilderModuleInput{
		ID:               id,
		Title:            title,
		Description:      &description,
		Topic:            topic,
		Difficulty:       difficulty,
		EstimatedMinutes: estMin,
		ContentHash:      modHash,
		IsOrgOwned:       isModuleOrgOwned,
		OriginalID:       origModID,
		Sections:         sections,
	}, nil
}
