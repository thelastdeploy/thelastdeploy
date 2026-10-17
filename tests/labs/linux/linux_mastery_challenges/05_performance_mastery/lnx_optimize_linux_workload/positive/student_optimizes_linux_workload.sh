#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Optimizes Linux Workload
# Lab: lnx-optimize-linux-workload
# ==============================================================================

# Step 1: Ensure mastery-perf directory exists
student_exec \
  --step-name "Ensure mastery-perf directory exists" \
  --cmd "mkdir -p ~/mastery-perf" \
  --expect-exit-code 0

# Step 2: Audit system workload and CPU metrics
student_exec \
  --step-name "Audit system workload and CPU metrics" \
  --cmd "lscpu | head -n 10 && cat /proc/loadavg" \
  --expect-exit-code 0

# Step 3: Write performance mastery marker
student_exec \
  --step-name "Write performance mastery marker" \
  --cmd "echo 'LINUX_WORKLOAD_PERFORMANCE_MASTERED' > ~/mastery-perf/perf_mastery.log" \
  --expect-exit-code 0

# Step 4: Verify perf_mastery.log content
student_exec \
  --step-name "Verify perf_mastery.log content" \
  --cmd "cat ~/mastery-perf/perf_mastery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "LINUX_WORKLOAD_PERFORMANCE_MASTERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Optimize Linux Workload verified successfully."
