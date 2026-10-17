#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Process Scheduling
# Lab: lnx-investigate-process-scheduling
# ==============================================================================

# Step 1: Ensure proc-sched directory exists
student_exec \
  --step-name "Ensure proc-sched directory exists" \
  --cmd "mkdir -p ~/proc-sched" \
  --expect-exit-code 0

# Step 2: Inspect scheduler details
student_exec \
  --step-name "Inspect process sched and schedstat" \
  --cmd "cat /proc/self/sched | head -n 15" \
  --expect-exit-code 0

# Step 3: Write scheduler investigation marker
student_exec \
  --step-name "Write sched investigation marker" \
  --cmd "echo 'PROCESS_SCHEDULER_VRUNTIME_EXAMINED' > ~/proc-sched/sched_investigation.log" \
  --expect-exit-code 0

# Step 4: Verify content of sched_investigation.log
student_exec \
  --step-name "Verify sched_investigation.log content" \
  --cmd "cat ~/proc-sched/sched_investigation.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PROCESS_SCHEDULER_VRUNTIME_EXAMINED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Investigate Process Scheduling verified successfully."
