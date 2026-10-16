#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Diagnoses Connection Failures with Verbose Mode
# Lab: lnx-diagnose-ssh-connection
# ==============================================================================

# Step 1: Ensure ssh-test directory exists
student_exec \
  --step-name "Create ssh-test directory" \
  --cmd "mkdir -p ~/ssh-test" \
  --expect-exit-code 0

# Step 2: Create debug_cmd.sh script using ssh -vvv for maximum debug verbosity
student_exec \
  --step-name "Create debug_cmd.sh script" \
  --cmd "cat << 'EOF' > ~/ssh-test/debug_cmd.sh
#!/bin/bash
ssh -vvv admin@10.0.0.50
EOF
chmod +x ~/ssh-test/debug_cmd.sh" \
  --expect-exit-code 0

# Step 3: Verify script is executable and contains ssh -vvv
student_exec \
  --step-name "Verify debug script" \
  --cmd "test -x ~/ssh-test/debug_cmd.sh && cat ~/ssh-test/debug_cmd.sh" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ssh -vvv"

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Verbose SSH debugging invocation verified."
