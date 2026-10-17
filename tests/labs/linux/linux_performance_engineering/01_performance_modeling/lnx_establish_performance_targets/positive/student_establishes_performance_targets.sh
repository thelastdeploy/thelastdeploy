#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Establishes SLA and Performance Targets
# Lab: lnx-establish-performance-targets
# ==============================================================================

# Step 1: Ensure perf-eng-test directory exists
student_exec \
  --step-name "Ensure perf-eng-test directory exists" \
  --cmd "mkdir -p ~/perf-eng-test" \
  --expect-exit-code 0

# Step 2: Define SLA and benchmark targets
student_exec \
  --step-name "Display SLA targets summary" \
  --cmd "echo 'Target: p95 < 50ms, p99 < 150ms, Throughput > 1000 RPS'" \
  --expect-exit-code 0

# Step 3: Write performance SLA targets marker
student_exec \
  --step-name "Write performance SLA targets marker" \
  --cmd "echo 'PERFORMANCE_SLA_TARGETS_DEFINED' > ~/perf-eng-test/sla_targets.txt" \
  --expect-exit-code 0

# Step 4: Verify content of sla_targets.txt
student_exec \
  --step-name "Verify sla_targets.txt content" \
  --cmd "cat ~/perf-eng-test/sla_targets.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PERFORMANCE_SLA_TARGETS_DEFINED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: SLA and performance targets establishment verified."
