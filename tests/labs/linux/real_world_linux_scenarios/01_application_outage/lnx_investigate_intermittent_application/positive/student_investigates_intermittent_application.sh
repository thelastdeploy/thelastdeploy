#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Intermittent Application Failures
# Lab: lnx-investigate-intermittent-application
# ==============================================================================

# Step 1: Ensure app-outage directory exists
student_exec \
  --step-name "Ensure app-outage directory exists" \
  --cmd "mkdir -p ~/app-outage" \
  --expect-exit-code 0

# Step 2: Inspect connection and process limits
student_exec \
  --step-name "Inspect connection and process limits" \
  --cmd "ulimit -n && ss -tulpn 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write intermittent root cause marker
student_exec \
  --step-name "Write intermittent root cause marker" \
  --cmd "echo 'INTERMITTENT_FAILURE_ROOT_CAUSE_DIAGNOSED' > ~/app-outage/intermittent_root_cause.txt" \
  --expect-exit-code 0

# Step 4: Verify root cause file content
student_exec \
  --step-name "Verify root cause file content" \
  --cmd "cat ~/app-outage/intermittent_root_cause.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "INTERMITTENT_FAILURE_ROOT_CAUSE_DIAGNOSED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Investigate Intermittent Application Failures verified successfully."
