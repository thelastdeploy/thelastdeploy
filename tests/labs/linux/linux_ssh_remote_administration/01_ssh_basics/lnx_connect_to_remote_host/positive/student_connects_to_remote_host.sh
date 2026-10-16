#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Connects to Remote Host via SSH
# Lab: lnx-connect-to-remote-host
# ==============================================================================

# Step 1: Create ssh-test directory
student_exec \
  --step-name "Create ssh-test directory" \
  --cmd "mkdir -p ~/ssh-test" \
  --expect-exit-code 0

# Step 2: Create connect.sh script with SSH connection syntax and executable permission
student_exec \
  --step-name "Create connect.sh script" \
  --cmd "cat << 'EOF' > ~/ssh-test/connect.sh
#!/bin/bash
ssh admin@10.0.0.50
EOF
chmod +x ~/ssh-test/connect.sh" \
  --expect-exit-code 0

# Step 3: Verify script content and execution bit
student_exec \
  --step-name "Verify connect.sh script" \
  --cmd "test -x ~/ssh-test/connect.sh && cat ~/ssh-test/connect.sh" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ssh admin@10.0.0.50"

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: SSH connection syntax validated."
