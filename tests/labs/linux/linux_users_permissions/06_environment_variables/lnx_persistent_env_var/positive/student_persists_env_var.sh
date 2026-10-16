#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Make an environment variable persistent
# Module: linux-users-permissions
# Section: 06-environment-variables
# Lab ID: lnx-persistent-env-var
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-persistent-env-var"

# Step 1: Student appends the persistent export to ~/.bashrc
student_exec "echo 'export PLATFORM_NAME=DevLabPlatform' >> ~/.bashrc" \
    --desc "Student appends export statement to ~/.bashrc" \
    --expect-exit 0

# Step 2: Student confirms ~/.bashrc contains the export entry
student_exec "grep 'PLATFORM_NAME' ~/.bashrc" \
    --desc "Student verifies entry is present in ~/.bashrc" \
    --expect-exit 0 \
    --expect-stdout "export PLATFORM_NAME=DevLabPlatform"

# Step 3: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Environment variable successfully persisted in ~/.bashrc."
