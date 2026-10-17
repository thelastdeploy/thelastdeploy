#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Identifies Root Cause of Production Outage
# Lab: lnx-identify-root-cause
# ==============================================================================

# Step 1: Ensure multi-inc-test directory exists
student_exec \
  --step-name "Ensure multi-inc-test directory exists" \
  --cmd "mkdir -p ~/multi-inc-test" \
  --expect-exit-code 0

# Step 2: Audit root cause evidence
student_exec \
  --step-name "Audit root cause evidence" \
  --cmd "df -h / && du -sh /var/log 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write root cause proof marker
student_exec \
  --step-name "Write root cause proof marker" \
  --cmd "echo 'ROOT_CAUSE_PROVED: DISK_FULL_TRIGGERED_DB_FAIL' > ~/multi-inc-test/root_cause_proof.txt" \
  --expect-exit-code 0

# Step 4: Verify root_cause_proof.txt content
student_exec \
  --step-name "Verify root_cause_proof.txt content" \
  --cmd "cat ~/multi-inc-test/root_cause_proof.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ROOT_CAUSE_PROVED: DISK_FULL_TRIGGERED_DB_FAIL"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Production outage root cause identification verified."
