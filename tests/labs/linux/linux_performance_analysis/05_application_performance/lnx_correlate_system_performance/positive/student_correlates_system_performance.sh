#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Correlates System Performance Metrics
# Lab: lnx-correlate-system-performance
# ==============================================================================

# Step 1: Ensure app-perf-test directory exists
student_exec \
  --step-name "Ensure app-perf-test directory exists" \
  --cmd "mkdir -p ~/app-perf-test" \
  --expect-exit-code 0

# Step 2: Check memory and I/O metrics
student_exec \
  --step-name "Check memory allocation" \
  --cmd "free -m" \
  --expect-exit-code 0

# Step 3: Write correlation report marker
student_exec \
  --step-name "Write correlation report marker" \
  --cmd "echo 'METRICS_CORRELATED: SYSTEM_HEALTHY' > ~/app-perf-test/correlation_report.txt" \
  --expect-exit-code 0

# Step 4: Verify content of correlation_report.txt
student_exec \
  --step-name "Verify correlation_report.txt content" \
  --cmd "cat ~/app-perf-test/correlation_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "METRICS_CORRELATED: SYSTEM_HEALTHY"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: System performance metrics correlation verified."
