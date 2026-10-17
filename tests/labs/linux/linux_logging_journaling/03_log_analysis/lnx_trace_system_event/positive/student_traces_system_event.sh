#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces System Event Timelines across Logs
# Lab: lnx-trace-system-event
# ==============================================================================

# Step 1: Ensure log-test directory exists with sample system_trace.log if missing
student_exec \
  --step-name "Ensure sample system_trace.log exists" \
  --cmd "mkdir -p ~/log-test && [ -f ~/log-test/system_trace.log ] || printf '10:00:01 session_id=1041 INIT\n10:00:02 session_id=1042 INIT\n10:00:03 session_id=1041 PROCESS\n10:00:04 session_id=1042 PAYLOAD_FAIL\n10:00:05 session_id=1042 TERMINATED\n' > ~/log-test/system_trace.log" \
  --expect-exit-code 0

# Step 2: Extract session_id=1042 lines to session_1042_trace.log
student_exec \
  --step-name "Extract session_id=1042 lines" \
  --cmd "grep 'session_id=1042' ~/log-test/system_trace.log > ~/log-test/session_1042_trace.log" \
  --expect-exit-code 0

# Step 3: Verify content of session_1042_trace.log
student_exec \
  --step-name "Verify session_1042_trace.log content" \
  --cmd "cat ~/log-test/session_1042_trace.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PAYLOAD_FAIL"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Session event tracing verified."
