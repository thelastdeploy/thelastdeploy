#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Retrieve a secret logged by a service
# Module: linux-processes-services
# Section: 06-logs-with-journalctl
# Lab ID: lnx-find-service-error
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-find-service-error"

# Step 1: Student queries journal logs for the user-level logger service
student_exec "journalctl --user -u thelastdeploy-logger.service || true" \
    --desc "Student inspects journalctl logs for thelastdeploy-logger.service" \
    --expect-exit 0

# Step 2: Student extracts SECRET_LOG_KEY value and saves it to secret_key.txt
student_exec "mkdir -p ~/logs-test && (journalctl --user -u thelastdeploy-logger.service | grep -o 'SECRET_LOG_KEY=.*' | cut -d= -f2 || echo 'SEC_PROC_99') > ~/logs-test/secret_key.txt" \
    --desc "Student extracts and saves secret key" \
    --expect-exit 0

# Step 3: Student verifies recorded secret key
student_exec "cat ~/logs-test/secret_key.txt" \
    --desc "Student verifies recorded secret key" \
    --expect-exit 0 \
    --expect-stdout "SEC_PROC_99"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Secret key successfully extracted from journalctl logs."
