#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Copies Files Remotely using SCP
# Lab: lnx-copy-files-with-scp
# ==============================================================================

# Step 1: Ensure ssh-test directory exists
student_exec \
  --step-name "Create ssh-test directory" \
  --cmd "mkdir -p ~/ssh-test" \
  --expect-exit-code 0

# Step 2: Create transfer_cmd.sh script with SCP file copy command
student_exec \
  --step-name "Create SCP transfer script" \
  --cmd "cat << 'EOF' > ~/ssh-test/transfer_cmd.sh
#!/bin/bash
scp app.tar.gz admin@10.0.0.50:/var/backups/
EOF
chmod +x ~/ssh-test/transfer_cmd.sh" \
  --expect-exit-code 0

# Step 3: Verify transfer script is executable and contains valid SCP syntax
student_exec \
  --step-name "Verify transfer script" \
  --cmd "test -x ~/ssh-test/transfer_cmd.sh && cat ~/ssh-test/transfer_cmd.sh" \
  --expect-exit-code 0 \
  --expect-stdout-contains "scp app.tar.gz admin@10.0.0.50:/var/backups/"

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: SCP file transfer command verified."
