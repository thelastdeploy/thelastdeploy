#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Models System Workload Profile
# Lab: lnx-model-system-workload
# ==============================================================================

# Step 1: Ensure perf-eng-test directory exists
student_exec \
  --step-name "Ensure perf-eng-test directory exists" \
  --cmd "mkdir -p ~/perf-eng-test" \
  --expect-exit-code 0

# Step 2: Inspect system workload statistics
student_exec \
  --step-name "Inspect system workload via uptime" \
  --cmd "uptime" \
  --expect-exit-code 0

# Step 3: Write workload model marker
student_exec \
  --step-name "Write workload model marker" \
  --cmd "echo 'WORKLOAD_MODEL_ESTABLISHED' > ~/perf-eng-test/workload_model.txt" \
  --expect-exit-code 0

# Step 4: Verify content of workload_model.txt
student_exec \
  --step-name "Verify workload_model.txt content" \
  --cmd "cat ~/perf-eng-test/workload_model.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "WORKLOAD_MODEL_ESTABLISHED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Workload profile modeling verified."
