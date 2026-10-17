#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Application Connection
# Lab: lnx-trace-application-connection
# ==============================================================================

# Step 1: Ensure net-test directory exists
student_exec \
  --step-name "Ensure net-test directory exists" \
  --cmd "mkdir -p ~/net-test" \
  --expect-exit-code 0

# Step 2: Inspect curl response headers
student_exec \
  --step-name "Inspect curl headers" \
  --cmd "cat ~/net-test/app_trace/curl_headers.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "502"

# Step 3: Write status code
student_exec \
  --step-name "Write status code" \
  --cmd "echo '502' > ~/net-test/status_code.txt" \
  --expect-exit-code 0

# Step 4: Verify content of status_code.txt
student_exec \
  --step-name "Verify status_code.txt content" \
  --cmd "cat ~/net-test/status_code.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "502"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUCCESS: Application HTTP connection status code traced correctly."
