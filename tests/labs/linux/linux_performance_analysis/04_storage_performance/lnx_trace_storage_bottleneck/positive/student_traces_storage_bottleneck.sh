#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Process Storage I/O Bottleneck
# Lab: lnx-trace-storage-bottleneck
# ==============================================================================

# Step 1: Ensure io-perf-test directory exists
student_exec \
  --step-name "Ensure io-perf-test directory exists" \
  --cmd "mkdir -p ~/io-perf-test" \
  --expect-exit-code 0

# Step 2: Trace process disk read/write throughput
student_exec \
  --step-name "Trace process disk throughput via pidstat" \
  --cmd "pidstat -d 1 3" \
  --expect-exit-code 0

# Step 3: Write offending I/O process marker
student_exec \
  --step-name "Write io pid marker" \
  --cmd "echo 'OFFENDING_IO_PROCESS_TRACED' > ~/io-perf-test/io_pid.txt" \
  --expect-exit-code 0

# Step 4: Verify content of io_pid.txt
student_exec \
  --step-name "Verify io_pid.txt content" \
  --cmd "cat ~/io-perf-test/io_pid.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "OFFENDING_IO_PROCESS_TRACED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Process storage I/O bottleneck tracing verified."
