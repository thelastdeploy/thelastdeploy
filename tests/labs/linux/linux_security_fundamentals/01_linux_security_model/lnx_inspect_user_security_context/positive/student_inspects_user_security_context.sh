#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Inspect User Security Context and Group Memberships
# Module: linux-security-fundamentals
# Section: 01-linux-security-model
# Lab ID: lnx-inspect-user-security-context
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-inspect-user-security-context"

# Step 1: Student inspects identity context using id
student_exec "id" \
    --desc "Student inspects current UID, GID, and security context" \
    --expect-exit 0

# Step 2: Student inspects username and supplementary groups
student_exec "echo \"\$(whoami): \$(groups)\"" \
    --desc "Student inspects username and group memberships" \
    --expect-exit 0

# Step 3: Student writes formatted security context into user_context.txt
student_exec "printf 'USER=%s\nUID=%s\nGROUPS=%s\n' \"\$USER\" \"\$(id -u)\" \"\$(id -Gn)\" > ~/sec-test/user_context.txt" \
    --desc "Student saves formatted security context to user_context.txt" \
    --expect-exit 0

# Step 4: Student verifies user_context.txt contents
student_exec "cat ~/sec-test/user_context.txt" \
    --desc "Student verifies security context summary" \
    --expect-exit 0 \
    --expect-stdout "USER="

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Security context inspection verified."
