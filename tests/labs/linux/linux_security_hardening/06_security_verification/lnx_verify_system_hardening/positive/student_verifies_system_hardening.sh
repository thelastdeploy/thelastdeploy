#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Verifies System Hardening and Compliance
# Lab: lnx-verify-system-hardening
# ==============================================================================

set -euo pipefail

LAB_ID="lnx-verify-system-hardening"

# Step 1: Create audit-test workspace directory
student_exec "mkdir -p ~/audit-test" \
    --desc "Student prepares audit-test directory" \
    --expect-exit 0

# Step 2: Create check_compliance.sh audit script
student_exec "cat << 'EOF' > ~/audit-test/check_compliance.sh
#!/bin/bash
echo '=== Security Compliance Check ==='
grep -E '^PermitRootLogin\s+no' /etc/ssh/sshd_config 2>/dev/null || true
EOF
chmod +x ~/audit-test/check_compliance.sh" \
    --desc "Student creates compliance audit script" \
    --expect-exit 0

# Step 3: Record compliance verification result in compliance.log
student_exec "echo 'SYSTEM_HARDENING_VERIFIED: PASS' > ~/audit-test/compliance.log" \
    --desc "Student writes compliance verification log" \
    --expect-exit 0

# Step 4: Verify compliance.log content
student_exec "cat ~/audit-test/compliance.log" \
    --desc "Student verifies compliance.log content" \
    --expect-exit 0 \
    --expect-stdout "SYSTEM_HARDENING_VERIFIED: PASS"

# Step 5: Execute validator verification via tld check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: System hardening verification and compliance audit verified."
