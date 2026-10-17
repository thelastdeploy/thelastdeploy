#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Analyzes CPU Saturation and Run Queue
# Lab: lnx-analyze-cpu-saturation
# ==============================================================================

# Step 1: Ensure cpu-perf-test directory exists
student_exec \
  --step-name "Ensure cpu-perf-test directory exists" \
  --cmd "mkdir -p ~/cpu-perf-test" \
  --expect-exit-code 0

# Step 2: Analyze CPU run queue
student_exec \
  --step-name "Analyze CPU run queue via vmstat" \
  --cmd "vmstat 1 3" \
  --expect-exit-code 0

# Step 3: Write analysis summary marker
student_exec \
  --step-name "Write cpu saturation marker" \
  --cmd "echo 'CPU_SATURATION_ANALYZED' > ~/cpu-perf-test/cpu_analysis.txt" \
  --expect-exit-code 0

# Step 4: Verify content of cpu_analysis.txt
student_exec \
  --step-name "Verify cpu_analysis.txt content" \
  --cmd "cat ~/cpu-perf-test/cpu_analysis.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CPU_SATURATION_ANALYZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: CPU saturation and run queue analysis verified."
