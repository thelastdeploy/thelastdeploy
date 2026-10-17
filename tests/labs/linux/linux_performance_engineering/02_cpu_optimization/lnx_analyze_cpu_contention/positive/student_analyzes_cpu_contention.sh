#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Analyzes CPU Scheduler Contention
# Lab: lnx-analyze-cpu-contention
# ==============================================================================

# Step 1: Ensure cpu-opt-test directory exists
student_exec \
  --step-name "Ensure cpu-opt-test directory exists" \
  --cmd "mkdir -p ~/cpu-opt-test" \
  --expect-exit-code 0

# Step 2: Inspect CPU context switching and NUMA statistics
student_exec \
  --step-name "Inspect CPU and system stats via vmstat" \
  --cmd "vmstat 1 3" \
  --expect-exit-code 0

# Step 3: Write CPU contention analysis marker
student_exec \
  --step-name "Write contention analysis marker" \
  --cmd "echo 'CPU_CONTENTION_ANALYZED' > ~/cpu-opt-test/contention_analysis.txt" \
  --expect-exit-code 0

# Step 4: Verify content of contention_analysis.txt
student_exec \
  --step-name "Verify contention_analysis.txt content" \
  --cmd "cat ~/cpu-opt-test/contention_analysis.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CPU_CONTENTION_ANALYZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: CPU scheduler contention analysis verified."
