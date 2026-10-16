#!/usr/bin/env bash
# ==============================================================================
# tests/global_config.sh — Global test configuration for The Last Deploy (TLD)
# ==============================================================================

export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Target CLI paths — Strictly enforce local dev binary and dev environment
export CLI_DEV="$PROJECT_ROOT/bin/tld-dev"
export CLI="$CLI_DEV"

# Enforce isolated dev configuration directory (keeps production ~/.tld untouched)
export TLD_DIR="$HOME/.tld-dev"
export TLD_CONFIG_DIR="$HOME/.tld-dev"
export TLD_ENVIRONMENT="local"

# Environment flags
export TLD_NON_INTERACTIVE="1"
export DEBIAN_FRONTEND="noninteractive"

# Test directories
export TESTS_DIR="$PROJECT_ROOT/tests"
export CORE_DIR="$TESTS_DIR/core"
export LABS_DIR="$TESTS_DIR/labs"
export REPORTS_DIR="$TESTS_DIR/reports"
export REPORT_GENERATOR="$TESTS_DIR/report_generator.py"

# Timeouts & defaults
export DEFAULT_STEP_TIMEOUT=15
export DEFAULT_LAB_TIMEOUT=120
