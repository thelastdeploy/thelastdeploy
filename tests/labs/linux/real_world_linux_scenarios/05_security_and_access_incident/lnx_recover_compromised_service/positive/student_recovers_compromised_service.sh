#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Compromised Service
# Lab: lnx-recover-compromised-service
# ==============================================================================

# Step 1: Ensure security-incident directory exists
student_exec \
  --step-name "Ensure security-incident directory exists" \
  --cmd "mkdir -p ~/security-incident" \
  --expect-exit-code 0

# Step 2: Inspect running processes and cron persistence locations
student_exec \
  --step-name "Inspect running processes and cron persistence locations" \
  --cmd "ps -ef | head -n 5 && ls -la /etc/cron* 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write incident containment marker
student_exec \
  --step-name "Write incident containment marker" \
  --cmd "echo 'COMPROMISED_SERVICE_CONTAINED_AND_RECOVERED' > ~/security-incident/incident_containment.log" \
  --expect-exit-code 0

# Step 4: Verify containment log content
student_exec \
  --step-name "Verify containment log content" \
  --cmd "cat ~/security-incident/incident_containment.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "COMPROMISED_SERVICE_CONTAINED_AND_RECOVERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Recover Compromised Service verified successfully."
