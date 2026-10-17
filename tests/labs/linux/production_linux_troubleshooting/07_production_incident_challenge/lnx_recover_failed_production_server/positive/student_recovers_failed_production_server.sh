#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Failed Production Server Capstone
# Lab: lnx-recover-failed-production-server
# ==============================================================================

# Step 1: Ensure incident-capstone directory exists
student_exec \
  --step-name "Ensure incident-capstone directory exists" \
  --cmd "mkdir -p ~/incident-capstone" \
  --expect-exit-code 0

# Step 2: Audit overall server health indicators
student_exec \
  --step-name "Audit overall server health indicators" \
  --cmd "uptime && df -h && free -m" \
  --expect-exit-code 0

# Step 3: Write post-mortem recovery report marker
student_exec \
  --step-name "Write post-mortem recovery report marker" \
  --cmd "echo 'PRODUCTION_INCIDENT_RESOLVED: SYSTEM_HEALTHY' > ~/incident-capstone/post_mortem.log" \
  --expect-exit-code 0

# Step 4: Verify post_mortem.log content
student_exec \
  --step-name "Verify post_mortem.log content" \
  --cmd "cat ~/incident-capstone/post_mortem.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PRODUCTION_INCIDENT_RESOLVED: SYSTEM_HEALTHY"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Production server outage recovery capstone verified."
