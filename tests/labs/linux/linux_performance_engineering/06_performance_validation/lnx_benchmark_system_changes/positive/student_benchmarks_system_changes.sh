#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Benchmarks and Validates System Tuning Changes
# Lab: lnx-benchmark-system-changes
# ==============================================================================

# Step 1: Ensure bench-test directory exists
student_exec \
  --step-name "Ensure bench-test directory exists" \
  --cmd "mkdir -p ~/bench-test" \
  --expect-exit-code 0

# Step 2: Check system uptime and resources
student_exec \
  --step-name "Check system uptime" \
  --cmd "uptime" \
  --expect-exit-code 0

# Step 3: Write benchmark comparison marker
student_exec \
  --step-name "Write benchmark comparison marker" \
  --cmd "echo 'BENCHMARK_VALIDATION_COMPLETE: IMPROVEMENT_PROVED' > ~/bench-test/benchmark_comparison.txt" \
  --expect-exit-code 0

# Step 4: Verify content of benchmark_comparison.txt
student_exec \
  --step-name "Verify benchmark_comparison.txt content" \
  --cmd "cat ~/bench-test/benchmark_comparison.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "BENCHMARK_VALIDATION_COMPLETE: IMPROVEMENT_PROVED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Benchmark and validation of system tuning changes verified."
