#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Analyzes Memory Pressure and Page Cache
# Lab: lnx-analyze-memory-pressure
# ==============================================================================

# Step 1: Ensure mem-perf-test directory exists
student_exec \
  --step-name "Ensure mem-perf-test directory exists" \
  --cmd "mkdir -p ~/mem-perf-test" \
  --expect-exit-code 0

# Step 2: Inspect memory and page cache
student_exec \
  --step-name "Inspect memory via free" \
  --cmd "free -m" \
  --expect-exit-code 0

# Step 3: Write memory pressure marker
student_exec \
  --step-name "Write memory report marker" \
  --cmd "echo 'MEMORY_PRESSURE_ANALYZED' > ~/mem-perf-test/mem_report.txt" \
  --expect-exit-code 0

# Step 4: Verify content of mem_report.txt
student_exec \
  --step-name "Verify mem_report.txt content" \
  --cmd "cat ~/mem-perf-test/mem_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "MEMORY_PRESSURE_ANALYZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Memory pressure and page cache analysis verified."
