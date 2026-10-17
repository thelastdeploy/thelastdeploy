#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Malicious Persistence Mechanisms
# Lab: lnx-investigate-persistence-mechanism
# ==============================================================================

# Step 1: Ensure suspicious-test directory exists
student_exec \
  --step-name "Ensure suspicious-test directory exists" \
  --cmd "mkdir -p ~/suspicious-test" \
  --expect-exit-code 0

# Step 2: Audit system persistence locations
student_exec \
  --step-name "Audit system persistence locations" \
  --cmd "ls -la /etc/cron* /etc/systemd/system/ 2>/dev/null | head -n 15 || true" \
  --expect-exit-code 0

# Step 3: Write persistence report marker
student_exec \
  --step-name "Write persistence report marker" \
  --cmd "echo 'PERSISTENCE_MECHANISM_DISCOVERED' > ~/suspicious-test/persistence_report.txt" \
  --expect-exit-code 0

# Step 4: Verify persistence_report.txt content
student_exec \
  --step-name "Verify persistence_report.txt content" \
  --cmd "cat ~/suspicious-test/persistence_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PERSISTENCE_MECHANISM_DISCOVERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Malicious persistence mechanism investigation verified."
