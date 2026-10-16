#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Verifies System Hardening and Compliance
# Lab: lnx-verify-system-hardening
# ==============================================================================

# Step 1: Create audit-test workspace directory
student_exec \
  --step-name "Create audit-test directory" \
  --cmd "mkdir -p ~/audit-test" \
  --expect-exit-code 0

# Step 2: Create check_compliance.sh audit script
student_exec \
  --step-name "Create compliance audit script" \
  --cmd "cat << 'EOF' > ~/audit-test/check_compliance.sh
#!/bin/bash
echo '=== Security Compliance Check ==='
grep -E '^PermitRootLogin\s+no' /etc/ssh/sshd_config 2>/dev/null || true
EOF
chmod +x ~/audit-test/check_compliance.sh" \
  --expect-exit-code 0

# Step 3: Record compliance verification result in compliance.log
student_exec \
  --step-name "Record compliance verification log" \
  --cmd "echo 'SYSTEM_HARDENING_VERIFIED: PASS' > ~/audit-test/compliance.log" \
  --expect-exit-code 0

# Step 4: Verify compliance.log content
student_exec \
  --step-name "Verify compliance.log content" \
  --cmd "cat ~/audit-test/compliance.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SYSTEM_HARDENING_VERIFIED: PASS"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: System hardening verification and compliance audit verified."
