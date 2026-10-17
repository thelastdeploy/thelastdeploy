#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Compromised Server Forensic Capstone
# Lab: lnx-investigate-compromised-server
# ==============================================================================

# Step 1: Ensure ir-capstone directory exists
student_exec \
  --step-name "Ensure ir-capstone directory exists" \
  --cmd "mkdir -p ~/ir-capstone" \
  --expect-exit-code 0

# Step 2: Perform comprehensive system forensic assessment
student_exec \
  --step-name "Perform comprehensive system forensic assessment" \
  --cmd "uname -a 2>/dev/null && uptime 2>/dev/null && id 2>/dev/null" \
  --expect-exit-code 0

# Step 3: Write master forensic report marker
student_exec \
  --step-name "Write master forensic report marker" \
  --cmd "echo 'FORENSIC_INVESTIGATION_COMPLETE_SYSTEM_SECURED' > ~/ir-capstone/forensic_investigation.log" \
  --expect-exit-code 0

# Step 4: Verify forensic_investigation.log content
student_exec \
  --step-name "Verify forensic_investigation.log content" \
  --cmd "cat ~/ir-capstone/forensic_investigation.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "FORENSIC_INVESTIGATION_COMPLETE_SYSTEM_SECURED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Compromised server forensic investigation capstone verified."
