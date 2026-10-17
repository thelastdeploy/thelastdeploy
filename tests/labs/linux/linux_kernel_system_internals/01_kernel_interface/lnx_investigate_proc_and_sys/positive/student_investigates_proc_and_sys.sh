#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates procfs and sysfs
# Lab: lnx-investigate-proc-and-sys
# ==============================================================================

# Step 1: Ensure kernel-interface directory exists
student_exec \
  --step-name "Ensure kernel-interface directory exists" \
  --cmd "mkdir -p ~/kernel-interface" \
  --expect-exit-code 0

# Step 2: Inspect status in /proc
student_exec \
  --step-name "Inspect process status in /proc" \
  --cmd "cat /proc/self/status | head -n 10" \
  --expect-exit-code 0

# Step 3: Write proc and sys analysis marker
student_exec \
  --step-name "Write proc and sys analysis marker" \
  --cmd "echo 'PROC_SYS_SUBSYSTEM_HIERARCHY_ANALYZED' > ~/kernel-interface/proc_sys_analysis.txt" \
  --expect-exit-code 0

# Step 4: Verify content of proc_sys_analysis.txt
student_exec \
  --step-name "Verify proc_sys_analysis.txt content" \
  --cmd "cat ~/kernel-interface/proc_sys_analysis.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PROC_SYS_SUBSYSTEM_HIERARCHY_ANALYZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Investigate procfs and sysfs verified successfully."
