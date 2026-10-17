#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Suspicious Process Activity
# Lab: lnx-investigate-suspicious-activity
# ==============================================================================

# Step 1: Ensure suspicious-test directory exists
student_exec \
  --step-name "Ensure suspicious-test directory exists" \
  --cmd "mkdir -p ~/suspicious-test" \
  --expect-exit-code 0

# Step 2: Audit running processes and deleted binaries
student_exec \
  --step-name "Audit running processes and deleted binaries" \
  --cmd "ls -d /proc/[0-9]*/exe 2>/dev/null | head -n 10 || true" \
  --expect-exit-code 0

# Step 3: Write suspicious process analysis marker
student_exec \
  --step-name "Write suspicious process analysis marker" \
  --cmd "echo 'SUSPICIOUS_PROCESS_INVESTIGATED' > ~/suspicious-test/process_analysis.txt" \
  --expect-exit-code 0

# Step 4: Verify process_analysis.txt content
student_exec \
  --step-name "Verify process_analysis.txt content" \
  --cmd "cat ~/suspicious-test/process_analysis.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUSPICIOUS_PROCESS_INVESTIGATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Suspicious process activity investigation verified."
