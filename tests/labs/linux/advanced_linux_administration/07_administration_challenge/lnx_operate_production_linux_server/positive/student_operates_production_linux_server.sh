#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Operates Production Linux Server Capstone
# Lab: lnx-operate-production-linux-server
# ==============================================================================

# Step 1: Ensure server-ops directory exists
student_exec \
  --step-name "Ensure server-ops directory exists" \
  --cmd "mkdir -p ~/server-ops" \
  --expect-exit-code 0

# Step 2: Audit comprehensive operational health
student_exec \
  --step-name "Audit comprehensive operational health" \
  --cmd "uptime && df -h && systemctl is-system-running 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write operationalization signoff marker
student_exec \
  --step-name "Write operationalization signoff marker" \
  --cmd "echo 'PRODUCTION_SERVER_OPERATIONALIZED_AND_SECURED' > ~/server-ops/operationalization_signoff.log" \
  --expect-exit-code 0

# Step 4: Verify operationalization_signoff.log content
student_exec \
  --step-name "Verify operationalization_signoff.log content" \
  --cmd "cat ~/server-ops/operationalization_signoff.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PRODUCTION_SERVER_OPERATIONALIZED_AND_SECURED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Operate Production Linux Server Capstone verified successfully."
