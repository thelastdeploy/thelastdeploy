#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Correlates Security Logs and Event Signatures
# Lab: lnx-correlate-security-events
# ==============================================================================

# Step 1: Ensure timeline-test directory exists
student_exec \
  --step-name "Ensure timeline-test directory exists" \
  --cmd "mkdir -p ~/timeline-test" \
  --expect-exit-code 0

# Step 2: Correlate sudo and ssh signatures
student_exec \
  --step-name "Correlate security logs" \
  --cmd "grep -E 'sudo:|sshd\[' /var/log/auth.log 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write event correlation marker
student_exec \
  --step-name "Write event correlation marker" \
  --cmd "echo 'SECURITY_EVENTS_CORRELATED' > ~/timeline-test/event_correlation.txt" \
  --expect-exit-code 0

# Step 4: Verify event_correlation.txt content
student_exec \
  --step-name "Verify event_correlation.txt content" \
  --cmd "cat ~/timeline-test/event_correlation.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SECURITY_EVENTS_CORRELATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Security logs and event signatures correlation verified."
