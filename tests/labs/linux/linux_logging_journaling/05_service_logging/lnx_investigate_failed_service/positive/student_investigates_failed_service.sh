#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Failed Service Crash Logs
# Lab: lnx-investigate-failed-service
# ==============================================================================

# Step 1: Ensure log-test directory exists with sample failed_service_journal.log if missing
student_exec \
  --step-name "Ensure sample failed_service_journal.log exists" \
  --cmd "mkdir -p ~/log-test && [ -f ~/log-test/failed_service_journal.log ] || printf '[INFO] Starting postgresql.service...\n[FATAL] Port 5432 already in use by process 2104\n[ERROR] Failed to start server daemon\n' > ~/log-test/failed_service_journal.log" \
  --expect-exit-code 0

# Step 2: Save the root cause failure message to service_root_cause.txt
student_exec \
  --step-name "Save root cause message to service_root_cause.txt" \
  --cmd "echo 'Port 5432 already in use' > ~/log-test/service_root_cause.txt" \
  --expect-exit-code 0

# Step 3: Verify content of service_root_cause.txt
student_exec \
  --step-name "Verify service_root_cause.txt content" \
  --cmd "cat ~/log-test/service_root_cause.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Port 5432 already in use"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Failed service crash root cause investigation verified."
