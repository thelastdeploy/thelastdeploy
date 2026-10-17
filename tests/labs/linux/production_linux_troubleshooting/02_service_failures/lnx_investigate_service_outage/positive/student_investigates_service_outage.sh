#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Production Service Outage
# Lab: lnx-investigate-service-outage
# ==============================================================================

# Step 1: Ensure svc-outage-test directory exists
student_exec \
  --step-name "Ensure svc-outage-test directory exists" \
  --cmd "mkdir -p ~/svc-outage-test" \
  --expect-exit-code 0

# Step 2: Inspect failing services and journal logs
student_exec \
  --step-name "Inspect failing services and journal logs" \
  --cmd "systemctl --failed --no-pager || true" \
  --expect-exit-code 0

# Step 3: Write service outage diagnosis marker
student_exec \
  --step-name "Write service outage diagnosis marker" \
  --cmd "echo 'SERVICE_OUTAGE_DIAGNOSED' > ~/svc-outage-test/outage_diag.txt" \
  --expect-exit-code 0

# Step 4: Verify outage_diag.txt content
student_exec \
  --step-name "Verify outage_diag.txt content" \
  --cmd "cat ~/svc-outage-test/outage_diag.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SERVICE_OUTAGE_DIAGNOSED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Production service outage investigation verified."
