#!/usr/bin/env bash
# ==============================================================================
# tests/core/ui_formatter.sh — Terminal UI styling, banners, and status output
# ==============================================================================

# ANSI Color Codes
BOLD="\033[1m"
DIM="\033[2m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

ui_banner() {
    echo -e "${CYAN}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║         The Last Deploy — Automated Lab Test Suite            ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

ui_section() {
    echo -e "\n${BOLD}${BLUE}==> $1${RESET}"
}

ui_step() {
    local num="$1"
    local desc="$2"
    echo -e "  ${CYAN}[Step $num]${RESET} $desc"
}

ui_cmd() {
    local cmd="$1"
    echo -e "    ${DIM}$ $cmd${RESET}"
}

ui_step_pass() {
    local msg="$1"
    echo -e "    ${GREEN}✓ Passed:${RESET} ${DIM}$msg${RESET}"
}

ui_step_fail() {
    local msg="$1"
    echo -e "    ${RED}✗ Failed:${RESET} $msg"
}

ui_lab_pass() {
    local lab_id="$1"
    local duration="$2"
    echo -e "\n${GREEN}${BOLD}✔ LAB PASSED: $lab_id (${duration}s)${RESET}\n"
}

ui_lab_fail() {
    local lab_id="$1"
    local reason="$2"
    local duration="$3"
    echo -e "\n${RED}${BOLD}✖ LAB FAILED: $lab_id (${duration}s)${RESET}"
    echo -e "  ${RED}Reason: $reason${RESET}\n"
}

ui_summary_box() {
    local total="$1"
    local passed="$2"
    local failed="$3"
    local duration="$4"

    echo -e "${BOLD}═══════════════════════════════════════════════════════════════${RESET}"
    echo -e "  ${WHITE}Total Executed:${RESET} $total | ${GREEN}Passed:${RESET} $passed | ${RED}Failed:${RESET} $failed | ${CYAN}Duration:${RESET} ${duration}s"
    echo -e "${BOLD}═══════════════════════════════════════════════════════════════${RESET}"
}
