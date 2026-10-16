#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Inspect Sudo Privileges with Sudo List
# Module: linux-security-fundamentals
# Section: 03-sudo-and-privilege
# Lab ID: lnx-inspect-sudo-access
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-inspect-sudo-access"

# Step 1: Student creates check_sudo.sh script invoking sudo -l
student_exec "printf '#!/bin/bash\nsudo -l\n' > ~/sec-test/check_sudo.sh" \
    --desc "Student writes sudo inspection script" \
    --expect-exit 0

# Step 2: Student makes check_sudo.sh executable
student_exec "chmod +x ~/sec-test/check_sudo.sh" \
    --desc "Student grants execute permissions on check_sudo.sh" \
    --expect-exit 0

# Step 3: Student verifies check_sudo.sh script contents
student_exec "cat ~/sec-test/check_sudo.sh" \
    --desc "Student confirms script contents" \
    --expect-exit 0 \
    --expect-stdout "sudo -l"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Sudo access inspection script verified."
