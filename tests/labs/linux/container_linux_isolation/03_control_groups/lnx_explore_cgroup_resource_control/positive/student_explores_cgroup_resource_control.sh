#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Explores cgroup Resource Control Hierarchy
# Lab: lnx-explore-cgroup-resource-control
# ==============================================================================

# Step 1: Ensure cgroup-test directory exists
student_exec \
  --step-name "Ensure cgroup-test directory exists" \
  --cmd "mkdir -p ~/cgroup-test" \
  --expect-exit-code 0

# Step 2: Inspect cgroup v2 controllers and structure
student_exec \
  --step-name "Inspect cgroup v2 controllers and structure" \
  --cmd "ls -la /sys/fs/cgroup/ 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write cgroup hierarchy exploration marker
student_exec \
  --step-name "Write cgroup hierarchy exploration marker" \
  --cmd "echo 'CGROUP_HIERARCHY_EXPLORED' > ~/cgroup-test/cgroup_info.txt" \
  --expect-exit-code 0

# Step 4: Verify cgroup_info.txt content
student_exec \
  --step-name "Verify cgroup_info.txt content" \
  --cmd "cat ~/cgroup-test/cgroup_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CGROUP_HIERARCHY_EXPLORED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: cgroup resource control hierarchy exploration verified."
