#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Modify Configuration Settings and Preserve Backups
# Module: linux-environment-configuration
# Section: 03-application-configuration
# Lab ID: lnx-modify-application-configuration
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-modify-application-configuration"

# Step 1: Student inspects existing configuration file
student_exec "cat ~/env-test/service.conf" \
    --desc "Student inspects original service.conf" \
    --expect-exit 0 \
    --expect-stdout "MAX_CONNECTIONS=100"

# Step 2: Student creates a safety backup of service.conf
student_exec "cp ~/env-test/service.conf ~/env-test/service.conf.bak" \
    --desc "Student creates backup copy service.conf.bak" \
    --expect-exit 0

# Step 3: Student verifies the backup retains original settings
student_exec "cat ~/env-test/service.conf.bak" \
    --desc "Student verifies backup file preserves original settings" \
    --expect-exit 0 \
    --expect-stdout "MAX_CONNECTIONS=100"

# Step 4: Student modifies MAX_CONNECTIONS in service.conf
student_exec "sed -i 's/MAX_CONNECTIONS=100/MAX_CONNECTIONS=500/' ~/env-test/service.conf" \
    --desc "Student updates MAX_CONNECTIONS to 500" \
    --expect-exit 0

# Step 5: Student verifies the modified configuration file
student_exec "cat ~/env-test/service.conf" \
    --desc "Student confirms updated configuration settings" \
    --expect-exit 0 \
    --expect-stdout "MAX_CONNECTIONS=500"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration modification and backup retention verified."
