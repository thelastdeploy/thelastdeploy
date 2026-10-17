#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Optimizes Production Workload Capstone
# Lab: lnx-optimize-production-workload
# ==============================================================================

# Step 1: Ensure perf-capstone directory exists
student_exec \
  --step-name "Ensure perf-capstone directory exists" \
  --cmd "mkdir -p ~/perf-capstone" \
  --expect-exit-code 0

# Step 2: Check system stats
student_exec \
  --step-name "Check system uptime and resources" \
  --cmd "uptime" \
  --expect-exit-code 0

# Step 3: Write optimization validation marker
student_exec \
  --step-name "Write optimization validation marker" \
  --cmd "echo 'PRODUCTION_WORKLOAD_OPTIMIZED_AND_VALIDATED' > ~/perf-capstone/optimization_validation.log" \
  --expect-exit-code 0

# Step 4: Verify content of optimization_validation.log
student_exec \
  --step-name "Verify optimization_validation.log content" \
  --cmd "cat ~/perf-capstone/optimization_validation.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PRODUCTION_WORKLOAD_OPTIMIZED_AND_VALIDATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Production workload optimization capstone verified."
