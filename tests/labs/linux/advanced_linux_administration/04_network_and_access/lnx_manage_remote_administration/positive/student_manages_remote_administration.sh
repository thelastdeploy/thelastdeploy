#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Manages Remote Administration
# Lab: lnx-manage-remote-administration
# ==============================================================================

# Step 1: Ensure net-sec directory exists
student_exec \
  --step-name "Ensure net-sec directory exists" \
  --cmd "mkdir -p ~/net-sec" \
  --expect-exit-code 0

# Step 2: Audit SSH and sudo configuration
student_exec \
  --step-name "Audit SSH and sudo configuration" \
  --cmd "sshd -T 2>/dev/null | grep -E 'passwordauthentication|permitrootlogin' || true" \
  --expect-exit-code 0

# Step 3: Write SSH and sudo hardening marker
student_exec \
  --step-name "Write SSH and sudo hardening marker" \
  --cmd "echo 'SSH_AND_SUDO_ACCESS_HARDENED' > ~/net-sec/ssh_hardening.conf" \
  --expect-exit-code 0

# Step 4: Verify ssh_hardening.conf content
student_exec \
  --step-name "Verify ssh_hardening.conf content" \
  --cmd "cat ~/net-sec/ssh_hardening.conf" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SSH_AND_SUDO_ACCESS_HARDENED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Manage Remote Administration verified successfully."
