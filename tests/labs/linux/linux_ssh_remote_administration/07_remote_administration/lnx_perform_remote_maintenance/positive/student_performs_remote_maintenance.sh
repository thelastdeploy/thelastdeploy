#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Performs Automated Remote Maintenance Across Hosts
# Lab: lnx-perform-remote-maintenance
# ==============================================================================

# Step 1: Ensure ssh-test directory exists
student_exec \
  --step-name "Create ssh-test directory" \
  --cmd "mkdir -p ~/ssh-test" \
  --expect-exit-code 0

# Step 2: Create maint_runner.sh script that iterates through web1, web2, web3
student_exec \
  --step-name "Create maint_runner.sh script" \
  --cmd "cat << 'EOF' > ~/ssh-test/maint_runner.sh
#!/bin/bash
LOG_PATH=\"\$HOME/ssh-test/maint_execution.log\"
> \"\$LOG_PATH\"
for HOST in web1 web2 web3; do
    echo \"MAINTENANCE_COMPLETE: \$HOST\" >> \"\$LOG_PATH\"
done
EOF
chmod +x ~/ssh-test/maint_runner.sh" \
  --expect-exit-code 0

# Step 3: Run maint_runner.sh script
student_exec \
  --step-name "Execute maint_runner.sh script" \
  --cmd "~/ssh-test/maint_runner.sh" \
  --expect-exit-code 0

# Step 4: Verify maintenance execution log entries
student_exec \
  --step-name "Verify maintenance log output" \
  --cmd "cat ~/ssh-test/maint_execution.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "MAINTENANCE_COMPLETE: web1"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Remote batch maintenance automation verified."
