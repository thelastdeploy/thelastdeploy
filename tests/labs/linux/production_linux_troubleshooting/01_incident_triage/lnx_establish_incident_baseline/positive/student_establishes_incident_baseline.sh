#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Establishes Incident State Baseline
# Lab: lnx-establish-incident-baseline
# ==============================================================================

# Step 1: Ensure triage-test directory exists
student_exec \
  --step-name "Ensure triage-test directory exists" \
  --cmd "mkdir -p ~/triage-test" \
  --expect-exit-code 0

# Step 2: Collect baseline diagnostic evidence
student_exec \
  --step-name "Collect baseline diagnostic evidence" \
  --cmd "dmesg | tail -n 10 || true" \
  --expect-exit-code 0

# Step 3: Write incident baseline marker
student_exec \
  --step-name "Write incident baseline marker" \
  --cmd "echo 'INCIDENT_BASELINE_ESTABLISHED' > ~/triage-test/incident_baseline.txt" \
  --expect-exit-code 0

# Step 4: Verify incident_baseline.txt content
student_exec \
  --step-name "Verify incident_baseline.txt content" \
  --cmd "cat ~/triage-test/incident_baseline.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "INCIDENT_BASELINE_ESTABLISHED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Incident state baseline establishment verified."
