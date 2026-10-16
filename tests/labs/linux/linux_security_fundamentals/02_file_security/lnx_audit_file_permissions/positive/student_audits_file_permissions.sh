#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Audit File Permissions and Octal Masks
# Module: linux-security-fundamentals
# Section: 02-file-security
# Lab ID: lnx-audit-file-permissions
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-audit-file-permissions"

# Step 1: Student inspects numeric permission modes using stat
student_exec "stat -c '%a %n' ~/sec-test/configs/*" \
    --desc "Student audits octal permission masks of configuration files" \
    --expect-exit 0 \
    --expect-stdout "777"

# Step 2: Student records audited modes into permission_audit.txt
student_exec "printf 'app.conf: %s\ndb.conf: %s\n' \"\$(stat -c '%a' ~/sec-test/configs/app.conf)\" \"\$(stat -c '%a' ~/sec-test/configs/db.conf)\" > ~/sec-test/permission_audit.txt" \
    --desc "Student writes formatted audit findings to permission_audit.txt" \
    --expect-exit 0

# Step 3: Student verifies contents of permission_audit.txt
student_exec "cat ~/sec-test/permission_audit.txt" \
    --desc "Student confirms audit report content" \
    --expect-exit 0 \
    --expect-stdout "app.conf: 777"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Permission audit file validated."
