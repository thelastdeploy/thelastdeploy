#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Process Execution Lifecycle
# Lab: lnx-trace-process-lifecycle
# ==============================================================================

# Step 1: Ensure proc-internals-test directory exists
student_exec \
  --step-name "Ensure proc-internals-test directory exists" \
  --cmd "mkdir -p ~/proc-internals-test" \
  --expect-exit-code 0

# Step 2: Trace process hierarchy
student_exec \
  --step-name "Inspect process hierarchy via ps" \
  --cmd "ps -ef | head -n 10" \
  --expect-exit-code 0

# Step 3: Write process lifecycle marker
student_exec \
  --step-name "Write process lifecycle marker" \
  --cmd "echo 'PROCESS_LIFECYCLE_TRACED' > ~/proc-internals-test/lifecycle.txt" \
  --expect-exit-code 0

# Step 4: Verify content of lifecycle.txt
student_exec \
  --step-name "Verify lifecycle.txt content" \
  --cmd "cat ~/proc-internals-test/lifecycle.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PROCESS_LIFECYCLE_TRACED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Process execution lifecycle tracing verified."
