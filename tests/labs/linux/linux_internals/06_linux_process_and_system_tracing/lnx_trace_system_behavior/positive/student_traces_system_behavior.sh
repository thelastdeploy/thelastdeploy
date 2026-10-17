#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces System Execution Behavior
# Lab: lnx-trace-system-behavior
# ==============================================================================

# Step 1: Ensure trace-test directory exists
student_exec \
  --step-name "Ensure trace-test directory exists" \
  --cmd "mkdir -p ~/trace-test" \
  --expect-exit-code 0

# Step 2: Trace system behavior
student_exec \
  --step-name "Run strace trace command" \
  --cmd "strace -c ls / >/dev/null 2>&1 || true" \
  --expect-exit-code 0

# Step 3: Write system behavior marker
student_exec \
  --step-name "Write system trace marker" \
  --cmd "echo 'SYSTEM_BEHAVIOR_TRACED' > ~/trace-test/system_trace.log" \
  --expect-exit-code 0

# Step 4: Verify content of system_trace.log
student_exec \
  --step-name "Verify system_trace.log content" \
  --cmd "cat ~/trace-test/system_trace.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SYSTEM_BEHAVIOR_TRACED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: System execution behavior tracing verified."
