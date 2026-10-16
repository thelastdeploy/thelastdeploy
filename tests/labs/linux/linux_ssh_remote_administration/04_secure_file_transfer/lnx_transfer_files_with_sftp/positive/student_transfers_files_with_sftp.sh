#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Transfers Files using SFTP Batch Commands
# Lab: lnx-transfer-files-with-sftp
# ==============================================================================

# Step 1: Ensure ssh-test directory exists
student_exec \
  --step-name "Create ssh-test directory" \
  --cmd "mkdir -p ~/ssh-test" \
  --expect-exit-code 0

# Step 2: Create sftp_batch.txt file with upload command and session exit
student_exec \
  --step-name "Create SFTP batch commands file" \
  --cmd "cat << 'EOF' > ~/ssh-test/sftp_batch.txt
put local_config.json /etc/app/config.json
bye
EOF" \
  --expect-exit-code 0

# Step 3: Verify batch file content
student_exec \
  --step-name "Verify SFTP batch file content" \
  --cmd "cat ~/ssh-test/sftp_batch.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "put local_config.json /etc/app/config.json"

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: SFTP batch file transfer script verified."
