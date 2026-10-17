#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Masters Linux Administration
# Lab: lnx-master-linux-administration
# ==============================================================================

# Step 1: Ensure mastery-admin directory exists
student_exec \
  --step-name "Ensure mastery-admin directory exists" \
  --cmd "mkdir -p ~/mastery-admin" \
  --expect-exit-code 0

# Step 2: Audit systemctl and journalctl status
student_exec \
  --step-name "Audit systemctl and journalctl status" \
  --cmd "systemctl is-system-running 2>/dev/null || true && journalctl -n 5 --no-pager 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write admin mastery marker
student_exec \
  --step-name "Write admin mastery marker" \
  --cmd "echo 'SYSTEM_ADMINISTRATION_MASTERED' > ~/mastery-admin/admin_mastery.log" \
  --expect-exit-code 0

# Step 4: Verify admin_mastery.log content
student_exec \
  --step-name "Verify admin_mastery.log content" \
  --cmd "cat ~/mastery-admin/admin_mastery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SYSTEM_ADMINISTRATION_MASTERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Master Linux Administration verified successfully."
