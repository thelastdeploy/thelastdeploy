#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Restore Corrupted Configuration from Backup
# Module: linux-environment-configuration
# Section: 05-configuration-troubleshooting
# Lab ID: lnx-restore-broken-configuration
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-restore-broken-configuration"

# Step 1: Student inspects the corrupted configuration
student_exec "cat ~/env-test/corrupted_server.conf" \
    --desc "Student inspects corrupted server configuration file" \
    --expect-exit 0 \
    --expect-stdout "CORRUPTED_SYNTAX_ERRORS_XXXXX"

# Step 2: Student inspects the backup configuration file
student_exec "cat ~/env-test/corrupted_server.conf.bak" \
    --desc "Student verifies valid backup contents" \
    --expect-exit 0 \
    --expect-stdout "PORT=8080"

# Step 3: Student overwrites corrupted configuration with backup
student_exec "cp ~/env-test/corrupted_server.conf.bak ~/env-test/corrupted_server.conf" \
    --desc "Student restores server configuration from backup copy" \
    --expect-exit 0

# Step 4: Student verifies that corrupted_server.conf is restored
student_exec "cat ~/env-test/corrupted_server.conf" \
    --desc "Student verifies restored server configuration" \
    --expect-exit 0 \
    --expect-stdout "DB_NAME=production"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration restored from backup successfully."
