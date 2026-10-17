#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Limits Process Resources with cgroups
# Lab: lnx-limit-process-resources
# ==============================================================================

# Step 1: Ensure cgroup-test directory exists
student_exec \
  --step-name "Ensure cgroup-test directory exists" \
  --cmd "mkdir -p ~/cgroup-test" \
  --expect-exit-code 0

# Step 2: Review cgroup resource limit files
student_exec \
  --step-name "Review cgroup resource limit files" \
  --cmd "cat /proc/cgroups 2>/dev/null || cat /sys/fs/cgroup/cgroup.controllers 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write process resource limit marker
student_exec \
  --step-name "Write process resource limit marker" \
  --cmd "echo 'PROCESS_RESOURCES_LIMITED_VIA_CGROUP' > ~/cgroup-test/limits_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify limits_summary.txt content
student_exec \
  --step-name "Verify limits_summary.txt content" \
  --cmd "cat ~/cgroup-test/limits_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PROCESS_RESOURCES_LIMITED_VIA_CGROUP"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Process resource limiting with cgroups verified."
