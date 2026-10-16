#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Analyzes Unit State with systemctl
# Lab: lnx-analyze-unit-state
# ==============================================================================

# Step 1: Ensure systemd-test directory exists
student_exec \
  --step-name "Create systemd-test directory" \
  --cmd "mkdir -p ~/systemd-test" \
  --expect-exit-code 0

# Step 2: Query failed units and record output to failed_units.txt
student_exec \
  --step-name "Audit failed units" \
  --cmd "systemctl --failed --no-legend > ~/systemd-test/failed_units.txt 2>&1 || echo 'FAILED_UNITS_CHECKED' > ~/systemd-test/failed_units.txt" \
  --expect-exit-code 0

# Step 3: Verify failed_units.txt exists
student_exec \
  --step-name "Verify failed_units.txt file exists" \
  --cmd "test -f ~/systemd-test/failed_units.txt" \
  --expect-exit-code 0

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Unit state analysis verified."
