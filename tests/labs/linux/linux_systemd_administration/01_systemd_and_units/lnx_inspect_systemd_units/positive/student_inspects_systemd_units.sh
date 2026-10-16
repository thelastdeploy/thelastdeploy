#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects systemd Units and Records Counts
# Lab: lnx-inspect-systemd-units
# ==============================================================================

# Step 1: Ensure systemd-test directory exists
student_exec \
  --step-name "Create systemd-test directory" \
  --cmd "mkdir -p ~/systemd-test" \
  --expect-exit-code 0

# Step 2: Query loaded services and timers count, outputting to units_info.txt
student_exec \
  --step-name "Gather systemd units count" \
  --cmd "SERVICES_COUNT=\$(systemctl list-units --type=service --no-legend 2>/dev/null | grep -c '\.service' || echo 0)
TIMERS_COUNT=\$(systemctl list-units --type=timer --no-legend 2>/dev/null | grep -c '\.timer' || echo 0)
echo \"SERVICES_COUNT: \$SERVICES_COUNT\" > ~/systemd-test/units_info.txt
echo \"TIMERS_COUNT: \$TIMERS_COUNT\" >> ~/systemd-test/units_info.txt" \
  --expect-exit-code 0

# Step 3: Verify units_info.txt file contents
student_exec \
  --step-name "Verify units_info.txt contents" \
  --cmd "cat ~/systemd-test/units_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SERVICES_COUNT: "

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: systemd unit inspection verified."
