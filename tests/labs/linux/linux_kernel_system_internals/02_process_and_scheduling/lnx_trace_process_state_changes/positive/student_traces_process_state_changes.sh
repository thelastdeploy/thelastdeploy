#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Process State Changes
# Lab: lnx-trace-process-state-changes
# ==============================================================================

# Step 1: Ensure proc-sched directory exists
student_exec \
  --step-name "Ensure proc-sched directory exists" \
  --cmd "mkdir -p ~/proc-sched" \
  --expect-exit-code 0

# Step 2: Inspect state and context switches in /proc/self/status
student_exec \
  --step-name "Inspect process state and context switches" \
  --cmd "grep -E '^(State|voluntary_ctxt_switches|nonvoluntary_ctxt_switches)' /proc/self/status" \
  --expect-exit-code 0

# Step 3: Write state trace marker
student_exec \
  --step-name "Write state trace marker" \
  --cmd "echo 'PROCESS_STATE_MACHINE_TRANSITIONS_TRACED' > ~/proc-sched/state_trace.log" \
  --expect-exit-code 0

# Step 4: Verify content of state_trace.log
student_exec \
  --step-name "Verify state_trace.log content" \
  --cmd "cat ~/proc-sched/state_trace.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PROCESS_STATE_MACHINE_TRANSITIONS_TRACED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Trace Process State Changes verified successfully."
