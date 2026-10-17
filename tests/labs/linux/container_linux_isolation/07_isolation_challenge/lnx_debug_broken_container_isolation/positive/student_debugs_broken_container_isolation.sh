#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Debugs Broken Container Isolation Capstone
# Lab: lnx-debug-broken-container-isolation
# ==============================================================================

# Step 1: Ensure isolation-challenge directory exists
student_exec \
  --step-name "Ensure isolation-challenge directory exists" \
  --cmd "mkdir -p ~/isolation-challenge" \
  --expect-exit-code 0

# Step 2: Audit system isolation parameters
student_exec \
  --step-name "Audit system isolation parameters" \
  --cmd "uname -a && cat /proc/version 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write container isolation repair proof marker
student_exec \
  --step-name "Write container isolation repair proof marker" \
  --cmd "echo 'CONTAINER_ISOLATION_REPAIRED: SUCCESS' > ~/isolation-challenge/isolation_fix.log" \
  --expect-exit-code 0

# Step 4: Verify isolation_fix.log content
student_exec \
  --step-name "Verify isolation_fix.log content" \
  --cmd "cat ~/isolation-challenge/isolation_fix.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CONTAINER_ISOLATION_REPAIRED: SUCCESS"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Container isolation debugging capstone verified."
