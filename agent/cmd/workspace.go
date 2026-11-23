// agent/cmd/workspace.go
package cmd

import (
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/thelastdeploy/agent/internal/config"
)

type OrganizationItem struct {
	ID      int      `json:"id"`
	Name    string   `json:"name"`
	Slug    string   `json:"slug"`
	Type    string   `json:"type"`
	Roles   []string `json:"roles"`
	TotalXP int      `json:"total_xp"`
}

func runWorkspace(args []string) error {
	cfg, err := config.Load()
	if err != nil {
		return fmt.Errorf("load config: %w", err)
	}

	if cfg.AuthToken == "" {
		return fmt.Errorf("you are not logged in. Run 'tld login' first")
	}

	// Fetch user's organizations
	err, code, body := getJSONRequest(cfg.APIBaseURL, "/organizations", cfg.AuthToken, 10*time.Second)
	if err != nil {
		return fmt.Errorf("could not reach API at %s: %w", cfg.APIBaseURL, err)
	}
	if code != 200 {
		return fmt.Errorf("failed to fetch workspaces (HTTP %d): %s", code, string(body))
	}

	var orgs []OrganizationItem
	if err := json.Unmarshal(body, &orgs); err != nil {
		return fmt.Errorf("parse organizations response: %w", err)
	}

	// Default active workspace is "tld" if not set
	currentActive := cfg.ActiveOrg
	if currentActive == "" {
		currentActive = "tld"
	}

	// Subcommands:
	// tld workspace
	// tld workspace list
	// tld workspace switch <slug>
	// tld workspace <slug>
	if len(args) == 0 || args[0] == "list" {
		printWorkspaceList(orgs, currentActive)
		return nil
	}

	targetSlug := args[0]
	if args[0] == "switch" {
		if len(args) < 2 {
			return fmt.Errorf("usage: tld workspace switch <organization-slug>")
		}
		targetSlug = args[1]
	}

	targetSlug = strings.ToLower(strings.TrimSpace(targetSlug))
	if targetSlug == "personal" {
		targetSlug = "tld"
	}

	// Validate target slug against user memberships
	var matchedOrg *OrganizationItem
	for i := range orgs {
		if strings.ToLower(orgs[i].Slug) == targetSlug {
			matchedOrg = &orgs[i]
			break
		}
	}

	if matchedOrg == nil {
		return fmt.Errorf("you do not have an active membership in organization '%s'", targetSlug)
	}

	// Clear previous workspace context & cache
	cfg.ActiveOrg = matchedOrg.Slug
	if err := config.Save(cfg); err != nil {
		return fmt.Errorf("save config: %w", err)
	}

	displayName := matchedOrg.Name
	if matchedOrg.Slug == "tld" {
		displayName = "Personal (The Last Deploy)"
	}

	fmt.Printf("\n\x1b[32m✓ Switched active workspace to: %s (%s)\x1b[0m\n", displayName, matchedOrg.Slug)
	fmt.Printf("  Role: %s • XP: %d\n", strings.Join(matchedOrg.Roles, ", "), matchedOrg.TotalXP)
	fmt.Println("  Subsequent operations (check, status, sync) will execute in this workspace context.")
	return nil
}

func printWorkspaceList(orgs []OrganizationItem, currentActive string) {
	fmt.Println("\x1b[1;36mAvailable Workspaces:\x1b[0m")
	for _, org := range orgs {
		isActive := strings.ToLower(org.Slug) == strings.ToLower(currentActive)
		marker := "  "
		badge := ""
		if isActive {
			marker = "\x1b[32m► \x1b[0m"
			badge = " \x1b[1;32m[active]\x1b[0m"
		}

		displayName := org.Name
		if org.Slug == "tld" {
			displayName = "Personal (The Last Deploy)"
		}

		rolesStr := "Member"
		if len(org.Roles) > 0 {
			rolesStr = strings.Join(org.Roles, ", ")
		}

		fmt.Printf("%s\x1b[1m%-28s\x1b[0m \x1b[33m(%s)\x1b[0m%s\n", marker, displayName, org.Slug, badge)
		fmt.Printf("    Role: %-15s XP: %d\n", rolesStr, org.TotalXP)
	}
	fmt.Println()
	fmt.Println("To switch active workspace, run:")
	fmt.Println("  \x1b[36mtld workspace switch <slug>\x1b[0m")
}
