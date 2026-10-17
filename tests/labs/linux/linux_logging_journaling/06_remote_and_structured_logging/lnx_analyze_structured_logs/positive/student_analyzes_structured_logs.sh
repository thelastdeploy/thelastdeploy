#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Analyzes Structured JSON Log Entries
# Lab: lnx-analyze-structured-logs
# ==============================================================================

# Step 1: Ensure log-test directory exists with sample events.json if missing
student_exec \
  --step-name "Ensure sample events.json exists" \
  --cmd "mkdir -p ~/log-test && [ -f ~/log-test/events.json ] || printf '{\"timestamp\":\"12:00:00\",\"level\":\"info\",\"service\":\"api\",\"msg\":\"ok\"}\n{\"timestamp\":\"12:01:00\",\"level\":\"error\",\"service\":\"auth\",\"msg\":\"token expired\"}\n{\"timestamp\":\"12:02:00\",\"level\":\"error\",\"service\":\"db\",\"msg\":\"connection timeout\"}\n' > ~/log-test/events.json" \
  --expect-exit-code 0

# Step 2: Filter error records from events.json into json_errors.txt
student_exec \
  --step-name "Filter error-level records" \
  --cmd "grep '\"level\":\"error\"' ~/log-test/events.json > ~/log-test/json_errors.txt" \
  --expect-exit-code 0

# Step 3: Verify content of json_errors.txt
student_exec \
  --step-name "Verify json_errors.txt content" \
  --cmd "cat ~/log-test/json_errors.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "token expired"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Structured JSON log analysis verified."
