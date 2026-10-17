#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Production Incident
# Lab: lnx-investigate-linux-production-incident
# ==============================================================================

# Step 1: Ensure mastery-incident directory exists
student_exec \
  --step-name "Ensure mastery-incident directory exists" \
  --cmd "mkdir -p ~/mastery-incident" \
  --expect-exit-code 0

# Step 2: Audit volatile process and socket states
student_exec \
  --step-name "Audit volatile process and socket states" \
  --cmd "ps aux | head -n 10 && ss -tuln" \
  --expect-exit-code 0

# Step 3: Write incident mastery marker
student_exec \
  --step-name "Write incident mastery marker" \
  --cmd "echo 'PRODUCTION_INCIDENT_INVESTIGATION_MASTERED' > ~/mastery-incident/incident_mastery.log" \
  --expect-exit-code 0

# Step 4: Verify incident_mastery.log content
student_exec \
  --step-name "Verify incident_mastery.log content" \
  --cmd "cat ~/mastery-incident/incident_mastery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PRODUCTION_INCIDENT_INVESTIGATION_MASTERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Investigate Production Incident verified successfully."
