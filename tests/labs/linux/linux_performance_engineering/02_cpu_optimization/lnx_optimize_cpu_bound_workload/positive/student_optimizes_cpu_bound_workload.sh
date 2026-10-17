#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Optimizes CPU-Bound Workload Execution
# Lab: lnx-optimize-cpu-bound-workload
# ==============================================================================

# Step 1: Ensure cpu-opt-test directory exists
student_exec \
  --step-name "Ensure cpu-opt-test directory exists" \
  --cmd "mkdir -p ~/cpu-opt-test" \
  --expect-exit-code 0

# Step 2: Test CPU core pinning via taskset
student_exec \
  --step-name "Run taskset core affinity check" \
  --cmd "taskset -c 0,1 echo 'Running on dedicated cores'" \
  --expect-exit-code 0

# Step 3: Write optimization report marker
student_exec \
  --step-name "Write cpu optimization marker" \
  --cmd "echo 'CPU_WORKLOAD_OPTIMIZED' > ~/cpu-opt-test/cpu_optimization.txt" \
  --expect-exit-code 0

# Step 4: Verify content of cpu_optimization.txt
student_exec \
  --step-name "Verify cpu_optimization.txt content" \
  --cmd "cat ~/cpu-opt-test/cpu_optimization.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CPU_WORKLOAD_OPTIMIZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: CPU-bound workload execution optimization verified."
