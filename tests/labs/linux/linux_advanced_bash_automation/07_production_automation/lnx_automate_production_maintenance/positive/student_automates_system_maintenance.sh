#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Automates System Maintenance Task
# Lab: lnx-automate-production-maintenance
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-automate-production-maintenance"

# Step 1: Ensure maint-test/logs directory exists and seed files
student_exec \
  --step-name "Ensure directory exists and seed test logs" \
  --cmd "mkdir -p ~/maint-test/logs && echo 'old log 1' > ~/maint-test/logs/old1.log && echo 'old log 2' > ~/maint-test/logs/old2.log && echo 'old log 3' > ~/maint-test/logs/old3.log && echo 'active log' > ~/maint-test/logs/active.log" \
  --expect-exit-code 0

# Step 2: Create maint.sh script
student_exec \
  --step-name "Create maint.sh script" \
  --cmd "cat << 'EOF' > ~/maint-test/maint.sh
#!/bin/bash
set -euo pipefail

LOG_DIR=\"\$HOME/maint-test/logs\"
SUMMARY=\"\$HOME/maint-test/maint_summary.log\"

gzip \"\$LOG_DIR\"/old*.log
echo \"MAINTENANCE_SUCCESS: 3 logs compressed\" >> \"\$SUMMARY\"
EOF
chmod +x ~/maint-test/maint.sh" \
  --expect-exit-code 0

# Step 3: Execute maint.sh
student_exec \
  --step-name "Execute maint.sh" \
  --cmd "~/maint-test/maint.sh" \
  --expect-exit-code 0

# Step 4: Verify summary output
student_exec \
  --step-name "Verify maint_summary.log content" \
  --cmd "cat ~/maint-test/maint_summary.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "MAINTENANCE_SUCCESS: 3 logs compressed"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Production system maintenance automation verified."
