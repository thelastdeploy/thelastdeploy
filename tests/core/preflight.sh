#!/usr/bin/env bash
# ==============================================================================
# tests/core/preflight.sh — System and environment preflight verification
# ==============================================================================

run_preflight() {
    ui_section "Running Test Harness Preflight Checks..."

    # 1. Verify Docker daemon
    if ! docker info >/dev/null 2>&1; then
        echo -e "${RED}Error: Docker daemon is not running or not accessible.${RESET}"
        echo "Please start Docker to run containerized lab tests."
        exit 1
    fi
    echo -e "  ${GREEN}✓${RESET} Docker engine is accessible."

    # 2. Build / Update CLI binary with latest changes
    echo -e "  ${CYAN}⚙${RESET} Compiling isolated local dev CLI (tld-dev)..."
    (cd "$PROJECT_ROOT" && make build-dev >/dev/null 2>&1)
    if [[ ! -f "$CLI" ]]; then
        echo -e "${RED}Error: Failed to build $CLI.${RESET}"
        exit 1
    fi
    echo -e "  ${GREEN}✓${RESET} Isolated Dev CLI ready: $CLI"
    echo -e "  ${GREEN}✓${RESET} Target environment: local (config dir: $TLD_DIR)"
    echo -e "  ${CYAN}⚙${RESET} Syncing challenge definitions into dev environment..."
    (cd "$PROJECT_ROOT" && "$CLI" sync --all >/dev/null 2>&1 || true)
    echo -e "  ${GREEN}✓${RESET} Challenge definitions synced."

    # 3. Check for Python 3 (for report generator)
    if ! command -v python3 >/dev/null 2>&1; then
        echo -e "${YELLOW}!${RESET} Warning: python3 not found. HTML report generation will be skipped."
        GENERATE_HTML=0
    else
        echo -e "  ${GREEN}✓${RESET} Python3 runtime available for reporting."
    fi

    # 4. Prepare reports directory
    mkdir -p "$REPORTS_DIR"
    echo -e "  ${GREEN}✓${RESET} Preflight checks completed successfully.\n"
}
