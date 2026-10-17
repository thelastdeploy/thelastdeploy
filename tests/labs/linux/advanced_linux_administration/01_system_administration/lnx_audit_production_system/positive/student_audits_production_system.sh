#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits Production System
# Lab: lnx-audit-production-system
# ==============================================================================

# Step 1: Ensure sysadmin-audit directory exists
student_exec \
  --step-name "Ensure sysadmin-audit directory exists" \
  --cmd "mkdir -p ~/sysadmin-audit" \
  --expect-exit-code 0

# Step 2: Audit system specs and listening ports
student_exec \
  --step-name "Audit system specs and listening ports" \
  --cmd "cat /etc/os-release && ss -tulpn 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write system inventory marker
student_exec \
  --step-name "Write system inventory marker" \
  --cmd "echo 'PRODUCTION_SERVER_AUDIT_COMPLETED' > ~/sysadmin-audit/system_inventory.log" \
  --expect-exit-code 0

# Step 4: Verify system_inventory.log content
student_exec \
  --step-name "Verify system_inventory.log content" \
  --cmd "cat ~/sysadmin-audit/system_inventory.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PRODUCTION_SERVER_AUDIT_COMPLETED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Audit Production System verified successfully."
