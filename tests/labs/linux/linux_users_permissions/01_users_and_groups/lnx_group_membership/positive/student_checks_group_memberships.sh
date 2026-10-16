#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Check your group memberships
# Module: linux-users-permissions
# Section: 01-users-and-groups
# Lab ID: lnx-group-membership
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-group-membership"

# Step 1: Student checks group memberships using groups command
student_exec "groups" \
    --desc "Student queries active group memberships using groups" \
    --expect-exit 0

# Step 2: Student tests alternative group inspection with id -Gn
student_exec "id -Gn" \
    --desc "Student inspects group names with id -Gn" \
    --expect-exit 0

# Step 3: Student saves group names into my_groups.txt
student_exec "groups > ~/users-groups-test/my_groups.txt" \
    --desc "Student writes group list into ~/users-groups-test/my_groups.txt" \
    --expect-exit 0

# Step 4: Student confirms the content of my_groups.txt
student_exec "cat ~/users-groups-test/my_groups.txt" \
    --desc "Student verifies the saved group memberships" \
    --expect-exit 0

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Group memberships successfully verified."
