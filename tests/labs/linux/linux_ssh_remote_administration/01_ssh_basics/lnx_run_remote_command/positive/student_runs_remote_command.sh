#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Runs Commands Remotely over SSH
# Lab: lnx-run-remote-command
# ==============================================================================

# Step 1: Ensure ssh-test directory exists
student_exec \
  --step-name "Create ssh-test directory" \
  --cmd "mkdir -p ~/ssh-test" \
  --expect-exit-code 0

# Step 2: Create remote_cmd.sh script with remote command execution syntax
student_exec \
  --step-name "Create remote_cmd.sh script" \
  --cmd "cat << 'EOF' > ~/ssh-test/remote_cmd.sh
#!/bin/bash
ssh admin@10.0.0.50 \"uptime\"
EOF
chmod +x ~/ssh-test/remote_cmd.sh" \
  --expect-exit-code 0

# Step 3: Verify script content and execution bit
student_exec \
  --step-name "Verify remote_cmd.sh script" \
  --cmd "test -x ~/ssh-test/remote_cmd.sh && cat ~/ssh-test/remote_cmd.sh" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ssh admin@10.0.0.50"

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Non-interactive SSH command execution validated."
