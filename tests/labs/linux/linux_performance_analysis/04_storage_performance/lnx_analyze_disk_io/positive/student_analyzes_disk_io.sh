#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Analyzes Disk I/O Utilization and Latency
# Lab: lnx-analyze-disk-io
# ==============================================================================

# Step 1: Ensure io-perf-test directory exists
student_exec \
  --step-name "Ensure io-perf-test directory exists" \
  --cmd "mkdir -p ~/io-perf-test" \
  --expect-exit-code 0

# Step 2: Inspect storage device throughput and latency
student_exec \
  --step-name "Inspect disk I/O metrics via iostat" \
  --cmd "iostat -xz 1 3" \
  --expect-exit-code 0

# Step 3: Write disk I/O analysis marker
student_exec \
  --step-name "Write disk io analysis marker" \
  --cmd "echo 'DISK_IO_ANALYZED' > ~/io-perf-test/io_analysis.txt" \
  --expect-exit-code 0

# Step 4: Verify content of io_analysis.txt
student_exec \
  --step-name "Verify io_analysis.txt content" \
  --cmd "cat ~/io-perf-test/io_analysis.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "DISK_IO_ANALYZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Disk I/O utilization and latency analysis verified."
