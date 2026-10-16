#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a system group
# Module: linux-users-permissions
# Section: 07-user-management
# Lab ID: lnx-create-group
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-create-group"

# Step 1: Student creates the dev-team group using sudo groupadd
student_exec "sudo groupadd dev-team" \
    --desc "Student creates group dev-team with groupadd" \
    --expect-exit 0

# Step 2: Student verifies the group exists in the system database
student_exec "getent group dev-team" \
    --desc "Student confirms dev-team exists via getent" \
    --expect-exit 0 \
    --expect-stdout "dev-team"

# Step 3: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Group 'dev-team' successfully created."
