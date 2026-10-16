#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Add user to a group
# Module: linux-users-permissions
# Section: 07-user-management
# Lab ID: lnx-add-user-group
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-add-user-group"

# Step 1: Student checks current group membership for dev-intern
student_exec "id -Gn dev-intern" \
    --desc "Student inspects dev-intern initial groups" \
    --expect-exit 0

# Step 2: Student adds dev-intern to secondary group dev-team
student_exec "sudo usermod -aG dev-team dev-intern" \
    --desc "Student adds dev-intern to dev-team with usermod -aG" \
    --expect-exit 0

# Step 3: Student verifies updated group membership
student_exec "id -Gn dev-intern" \
    --desc "Student confirms dev-team membership using id -Gn" \
    --expect-exit 0 \
    --expect-stdout "dev-team"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: User 'dev-intern' successfully added to group 'dev-team'."
