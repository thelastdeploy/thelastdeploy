#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Identify your active username
# Module: linux-users-permissions
# Section: 01-users-and-groups
# Lab ID: lnx-identify-user
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-identify-user"

# Step 1: Student runs whoami to query active username
student_exec "whoami" \
    --desc "Student queries active username using whoami" \
    --expect-exit 0

# Step 2: Student inspects full user id information
student_exec "id" \
    --desc "Student inspects uid, gid, and groups with id" \
    --expect-exit 0 \
    --expect-stdout "uid="

# Step 3: Student saves current username into current_user.txt
student_exec "whoami > ~/users-groups-test/current_user.txt" \
    --desc "Student writes current username to current_user.txt" \
    --expect-exit 0

# Step 4: Student confirms the content of current_user.txt
student_exec "cat ~/users-groups-test/current_user.txt" \
    --desc "Student verifies the saved username" \
    --expect-exit 0

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Username successfully identified and saved."
