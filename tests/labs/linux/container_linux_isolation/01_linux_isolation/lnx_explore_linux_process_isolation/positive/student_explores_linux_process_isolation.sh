#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Explores Linux Process Isolation
# Lab: lnx-explore-linux-process-isolation
# ==============================================================================

# Step 1: Ensure iso-test directory exists
student_exec \
  --step-name "Ensure iso-test directory exists" \
  --cmd "mkdir -p ~/iso-test" \
  --expect-exit-code 0

# Step 2: Audit process namespaces and host visibility
student_exec \
  --step-name "Audit process namespaces and host visibility" \
  --cmd "ls -l /proc/self/ns/ 2>/dev/null && ps -ef | head -n 5" \
  --expect-exit-code 0

# Step 3: Write process isolation exploration marker
student_exec \
  --step-name "Write process isolation exploration marker" \
  --cmd "echo 'PROCESS_ISOLATION_EXPLORED' > ~/iso-test/isolation_basics.txt" \
  --expect-exit-code 0

# Step 4: Verify isolation_basics.txt content
student_exec \
  --step-name "Verify isolation_basics.txt content" \
  --cmd "cat ~/iso-test/isolation_basics.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PROCESS_ISOLATION_EXPLORED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Linux process isolation exploration verified."
