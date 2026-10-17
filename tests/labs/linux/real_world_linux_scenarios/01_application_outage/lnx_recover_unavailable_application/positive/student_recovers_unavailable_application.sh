#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Unavailable Application
# Lab: lnx-recover-unavailable-application
# ==============================================================================

# Step 1: Ensure app-outage directory exists
student_exec \
  --step-name "Ensure app-outage directory exists" \
  --cmd "mkdir -p ~/app-outage" \
  --expect-exit-code 0

# Step 2: Investigate service outage status
student_exec \
  --step-name "Investigate service outage status" \
  --cmd "uptime && ss -xlp 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write application recovery marker
student_exec \
  --step-name "Write application recovery marker" \
  --cmd "echo 'UNAVAILABLE_APPLICATION_RECOVERED_SUCCESSFULLY' > ~/app-outage/application_recovery.log" \
  --expect-exit-code 0

# Step 4: Verify recovery log content
student_exec \
  --step-name "Verify recovery log content" \
  --cmd "cat ~/app-outage/application_recovery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "UNAVAILABLE_APPLICATION_RECOVERED_SUCCESSFULLY"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Recover Unavailable Application verified successfully."
