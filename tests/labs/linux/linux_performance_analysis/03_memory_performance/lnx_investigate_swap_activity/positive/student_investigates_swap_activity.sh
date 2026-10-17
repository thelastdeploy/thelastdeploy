#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Swap Activity and Page Faults
# Lab: lnx-investigate-swap-activity
# ==============================================================================

# Step 1: Ensure mem-perf-test directory exists
student_exec \
  --step-name "Ensure mem-perf-test directory exists" \
  --cmd "mkdir -p ~/mem-perf-test" \
  --expect-exit-code 0

# Step 2: Inspect swap statistics via vmstat
student_exec \
  --step-name "Inspect swap activity via vmstat" \
  --cmd "vmstat 1 3" \
  --expect-exit-code 0

# Step 3: Write swap investigation marker
student_exec \
  --step-name "Write swap report marker" \
  --cmd "echo 'SWAP_ACTIVITY_INVESTIGATED' > ~/mem-perf-test/swap_report.txt" \
  --expect-exit-code 0

# Step 4: Verify content of swap_report.txt
student_exec \
  --step-name "Verify swap_report.txt content" \
  --cmd "cat ~/mem-perf-test/swap_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SWAP_ACTIVITY_INVESTIGATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Swap activity and page fault investigation verified."
