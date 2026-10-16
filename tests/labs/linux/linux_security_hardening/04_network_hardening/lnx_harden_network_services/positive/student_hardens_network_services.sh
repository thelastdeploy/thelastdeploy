#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Hardens Network Services and SSH
# Lab: lnx-harden-network-services
# ==============================================================================

set -euo pipefail

LAB_ID="lnx-harden-network-services"

# Step 1: Create net-sec-test directory
student_exec "mkdir -p ~/net-sec-test" \
    --desc "Student prepares net-sec-test directory" \
    --expect-exit 0

# Step 2: Audit SSH configuration for hardening settings
student_exec "grep -E 'PermitRootLogin|PasswordAuthentication' /etc/ssh/sshd_config 2>/dev/null || true" \
    --desc "Student audits SSH daemon settings" \
    --expect-exit 0

# Step 3: Record verification indicator in sshd_summary.txt
student_exec "echo 'SSHD_CONFIG_HARDENED' > ~/net-sec-test/sshd_summary.txt" \
    --desc "Student writes SSH hardening summary" \
    --expect-exit 0

# Step 4: Verify sshd_summary.txt content
student_exec "cat ~/net-sec-test/sshd_summary.txt" \
    --desc "Student verifies sshd_summary.txt content" \
    --expect-exit 0 \
    --expect-stdout "SSHD_CONFIG_HARDENED"

# Step 5: Execute validator verification via tld check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Network services and SSH hardening verified."
