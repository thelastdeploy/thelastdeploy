#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Resource-Exhausted Server
# Lab: lnx-recover-resource-exhausted-server
# ==============================================================================

# Step 1: Ensure resource-crisis directory exists
student_exec \
  --step-name "Ensure resource-crisis directory exists" \
  --cmd "mkdir -p ~/resource-crisis" \
  --expect-exit-code 0

# Step 2: Check memory and OOM indicators
student_exec \
  --step-name "Check memory and OOM indicators" \
  --cmd "free -m && head -n 10 /proc/meminfo" \
  --expect-exit-code 0

# Step 3: Write oom recovery marker
student_exec \
  --step-name "Write oom recovery marker" \
  --cmd "echo 'RESOURCE_EXHAUSTED_SERVER_RECOVERED' > ~/resource-crisis/oom_recovery.log" \
  --expect-exit-code 0

# Step 4: Verify recovery log content
student_exec \
  --step-name "Verify recovery log content" \
  --cmd "cat ~/resource-crisis/oom_recovery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "RESOURCE_EXHAUSTED_SERVER_RECOVERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Recover Resource-Exhausted Server verified successfully."
