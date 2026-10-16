#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Configures Authorized Keys and File Permissions
# Lab: lnx-configure-key-authentication
# ==============================================================================

# Step 1: Ensure destination .ssh directory exists
student_exec \
  --step-name "Ensure server_home .ssh directory exists" \
  --cmd "mkdir -p ~/ssh-test/server_home/.ssh" \
  --expect-exit-code 0

# Step 2: Append public key to authorized_keys
student_exec \
  --step-name "Append public key to authorized_keys" \
  --cmd "cat ~/ssh-test/key_dir/id_ed25519.pub >> ~/ssh-test/server_home/.ssh/authorized_keys" \
  --expect-exit-code 0

# Step 3: Restrict authorized_keys file permissions to 600
student_exec \
  --step-name "Set authorized_keys permissions to 600" \
  --cmd "chmod 600 ~/ssh-test/server_home/.ssh/authorized_keys" \
  --expect-exit-code 0

# Step 4: Verify permissions and content of authorized_keys
student_exec \
  --step-name "Verify authorized_keys permissions and content" \
  --cmd "stat -c '%a' ~/ssh-test/server_home/.ssh/authorized_keys && grep 'ssh-ed25519' ~/ssh-test/server_home/.ssh/authorized_keys" \
  --expect-exit-code 0 \
  --expect-stdout-contains "600"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Key authentication configuration and permissions verified."
