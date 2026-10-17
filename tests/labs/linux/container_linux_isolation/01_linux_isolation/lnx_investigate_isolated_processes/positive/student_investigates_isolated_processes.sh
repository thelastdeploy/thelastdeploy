#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Isolated Process States
# Lab: lnx-investigate-isolated-processes
# ==============================================================================

# Step 1: Ensure iso-test directory exists
student_exec \
  --step-name "Ensure iso-test directory exists" \
  --cmd "mkdir -p ~/iso-test" \
  --expect-exit-code 0

# Step 2: Inspect process isolation attributes
student_exec \
  --step-name "Inspect process isolation attributes" \
  --cmd "readlink /proc/$$/ns/pid 2>/dev/null || true && cat /proc/$$/status | grep -i NSpid || true" \
  --expect-exit-code 0

# Step 3: Write isolated processes investigation marker
student_exec \
  --step-name "Write isolated processes investigation marker" \
  --cmd "echo 'ISOLATED_PROCESSES_INVESTIGATED' > ~/iso-test/proc_isolation.txt" \
  --expect-exit-code 0

# Step 4: Verify proc_isolation.txt content
student_exec \
  --step-name "Verify proc_isolation.txt content" \
  --cmd "cat ~/iso-test/proc_isolation.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ISOLATED_PROCESSES_INVESTIGATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Isolated process state investigation verified."
