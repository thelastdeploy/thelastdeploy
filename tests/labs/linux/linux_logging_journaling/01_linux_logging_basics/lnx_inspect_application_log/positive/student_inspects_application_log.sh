#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Application Log Streams
# Lab: lnx-inspect-application-log
# ==============================================================================

# Step 1: Ensure log-test and app_logs directories exist with sample web_access.log if missing
student_exec \
  --step-name "Ensure sample web_access.log exists" \
  --cmd "mkdir -p ~/log-test/app_logs && [ -f ~/log-test/app_logs/web_access.log ] || seq 1 30 | sed 's/^/192.168.1.1 GET \/item\//' > ~/log-test/app_logs/web_access.log" \
  --expect-exit-code 0

# Step 2: Extract last 10 lines of web_access.log into recent_access.log
student_exec \
  --step-name "Extract last 10 lines to recent_access.log" \
  --cmd "tail -n 10 ~/log-test/app_logs/web_access.log > ~/log-test/recent_access.log" \
  --expect-exit-code 0

# Step 3: Verify recent_access.log line count
student_exec \
  --step-name "Verify line count of recent_access.log" \
  --cmd "wc -l < ~/log-test/recent_access.log | tr -d ' '" \
  --expect-exit-code 0 \
  --expect-stdout-contains "10"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Application log inspection verified."
