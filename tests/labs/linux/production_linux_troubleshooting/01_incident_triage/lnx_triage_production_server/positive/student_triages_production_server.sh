#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Triages Production Server Incident
# Lab: lnx-triage-production-server
# ==============================================================================

# Step 1: Ensure triage-test directory exists
student_exec \
  --step-name "Ensure triage-test directory exists" \
  --cmd "mkdir -p ~/triage-test" \
  --expect-exit-code 0

# Step 2: Run emergency incident triage commands
student_exec \
  --step-name "Run emergency incident triage commands" \
  --cmd "uptime && df -h | head -n 5 && free -m" \
  --expect-exit-code 0

# Step 3: Write triage summary marker
student_exec \
  --step-name "Write triage summary marker" \
  --cmd "echo 'PRODUCTION_SERVER_TRIAGED' > ~/triage-test/triage_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify triage_summary.txt content
student_exec \
  --step-name "Verify triage_summary.txt content" \
  --cmd "cat ~/triage-test/triage_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PRODUCTION_SERVER_TRIAGED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Production server incident triage verified."
