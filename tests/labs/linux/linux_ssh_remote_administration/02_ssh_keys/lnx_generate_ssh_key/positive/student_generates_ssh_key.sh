#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Generates ED25519 SSH Keypair
# Lab: lnx-generate-ssh-key
# ==============================================================================

# Step 1: Create ssh-test/key_dir directory
student_exec \
  --step-name "Create key_dir directory" \
  --cmd "mkdir -p ~/ssh-test/key_dir" \
  --expect-exit-code 0

# Step 2: Generate ED25519 SSH keypair with no passphrase
student_exec \
  --step-name "Generate SSH keypair" \
  --cmd "ssh-keygen -t ed25519 -N '' -f ~/ssh-test/key_dir/id_ed25519" \
  --expect-exit-code 0

# Step 3: Verify private and public key files exist
student_exec \
  --step-name "Verify key files exist" \
  --cmd "ls -la ~/ssh-test/key_dir/" \
  --expect-exit-code 0 \
  --expect-stdout-contains "id_ed25519"

# Step 4: Verify public key contents
student_exec \
  --step-name "Verify public key format" \
  --cmd "cat ~/ssh-test/key_dir/id_ed25519.pub" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ssh-ed25519"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: SSH keypair generation verified."
