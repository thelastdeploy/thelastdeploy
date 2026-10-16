#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Restores OpenSSH Directory and Key Permissions
# Lab: lnx-fix-ssh-authentication
# ==============================================================================

# Step 1: Fix directory permissions on .ssh to 700
student_exec \
  --step-name "Restore .ssh directory permissions to 700" \
  --cmd "chmod 700 ~/ssh-test/broken_ssh/.ssh" \
  --expect-exit-code 0

# Step 2: Fix file permissions on authorized_keys to 600
student_exec \
  --step-name "Restore authorized_keys file permissions to 600" \
  --cmd "chmod 600 ~/ssh-test/broken_ssh/.ssh/authorized_keys" \
  --expect-exit-code 0

# Step 3: Verify restored directory and file permissions
student_exec \
  --step-name "Verify permissions" \
  --cmd "stat -c '%a' ~/ssh-test/broken_ssh/.ssh && stat -c '%a' ~/ssh-test/broken_ssh/.ssh/authorized_keys" \
  --expect-exit-code 0 \
  --expect-stdout-contains "700"

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: SSH directory and authorized_keys file permissions restored."
