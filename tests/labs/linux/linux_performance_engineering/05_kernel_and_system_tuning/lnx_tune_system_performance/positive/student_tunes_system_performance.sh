#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Tunes System Performance Parameters
# Lab: lnx-tune-system-performance
# ==============================================================================

# Step 1: Ensure kernel-opt-test directory exists
student_exec \
  --step-name "Ensure kernel-opt-test directory exists" \
  --cmd "mkdir -p ~/kernel-opt-test" \
  --expect-exit-code 0

# Step 2: Check current network tuning parameters
student_exec \
  --step-name "Check somaxconn tuning parameter" \
  --cmd "sysctl -a 2>/dev/null | grep somaxconn || true" \
  --expect-exit-code 0

# Step 3: Write system performance tuned marker
student_exec \
  --step-name "Write system tuned marker" \
  --cmd "echo 'SYSTEM_PERFORMANCE_TUNED' > ~/kernel-opt-test/system_tuned.txt" \
  --expect-exit-code 0

# Step 4: Verify content of system_tuned.txt
student_exec \
  --step-name "Verify system_tuned.txt content" \
  --cmd "cat ~/kernel-opt-test/system_tuned.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SYSTEM_PERFORMANCE_TUNED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: System performance parameters tuning verified."
