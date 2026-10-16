#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Inspect Active Configuration Settings
# Module: linux-environment-configuration
# Section: 03-application-configuration
# Lab ID: lnx-inspect-configuration-settings
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-inspect-configuration-settings"

# Step 1: Student inspects the raw web.conf file containing comments
student_exec "cat ~/env-test/web.conf" \
    --desc "Student views web.conf containing commented and active parameters" \
    --expect-exit 0 \
    --expect-stdout "PORT=8080"

# Step 2: Student filters comments and blank lines into active_settings.txt
student_exec "grep -v '^[[:space:]]*#' ~/env-test/web.conf | grep -v '^[[:space:]]*$' > ~/env-test/active_settings.txt" \
    --desc "Student extracts active non-comment settings to active_settings.txt" \
    --expect-exit 0

# Step 3: Student confirms extracted active settings
student_exec "cat ~/env-test/active_settings.txt" \
    --desc "Student verifies extracted active settings" \
    --expect-exit 0 \
    --expect-stdout "WORKERS=4"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Active configuration settings extraction verified."
