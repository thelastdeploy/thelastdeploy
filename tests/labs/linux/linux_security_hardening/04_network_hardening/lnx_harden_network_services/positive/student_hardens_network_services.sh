#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Hardens Network Services and SSH
# Lab: lnx-harden-network-services
# ==============================================================================

# Step 1: Create net-sec-test directory
student_exec \
  --step-name "Create net-sec-test directory" \
  --cmd "mkdir -p ~/net-sec-test" \
  --expect-exit-code 0

# Step 2: Audit SSH configuration for hardening settings
student_exec \
  --step-name "Audit SSH daemon settings" \
  --cmd "grep -E 'PermitRootLogin|PasswordAuthentication' /etc/ssh/sshd_config 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Record verification indicator in sshd_summary.txt
student_exec \
  --step-name "Record SSH hardening summary" \
  --cmd "echo 'SSHD_CONFIG_HARDENED' > ~/net-sec-test/sshd_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify sshd_summary.txt content
student_exec \
  --step-name "Verify sshd_summary.txt content" \
  --cmd "cat ~/net-sec-test/sshd_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SSHD_CONFIG_HARDENED"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Network services and SSH hardening verified."
