#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Identifies and Traces CPU Intensive Workload
# Lab: lnx-trace-cpu-intensive-workload
# ==============================================================================

# Step 1: Ensure cpu-perf-test directory exists
student_exec \
  --step-name "Ensure cpu-perf-test directory exists" \
  --cmd "mkdir -p ~/cpu-perf-test" \
  --expect-exit-code 0

# Step 2: Inspect top CPU processes
student_exec \
  --step-name "Inspect top CPU processes" \
  --cmd "ps aux --sort=-%cpu | head -n 5" \
  --expect-exit-code 0

# Step 3: Write process identification marker
student_exec \
  --step-name "Write offending PID marker" \
  --cmd "echo 'OFFENDING_CPU_PROCESS_IDENTIFIED' > ~/cpu-perf-test/offending_pid.txt" \
  --expect-exit-code 0

# Step 4: Verify content of offending_pid.txt
student_exec \
  --step-name "Verify offending_pid.txt content" \
  --cmd "cat ~/cpu-perf-test/offending_pid.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "OFFENDING_CPU_PROCESS_IDENTIFIED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: CPU-intensive workload process tracing verified."
