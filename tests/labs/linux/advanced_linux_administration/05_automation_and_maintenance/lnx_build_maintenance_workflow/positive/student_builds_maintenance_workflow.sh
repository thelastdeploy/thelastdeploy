#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Builds Maintenance Workflow
# Lab: lnx-build-maintenance-workflow
# ==============================================================================

# Step 1: Ensure admin-auto directory exists
student_exec \
  --step-name "Ensure admin-auto directory exists" \
  --cmd "mkdir -p ~/admin-auto" \
  --expect-exit-code 0

# Step 2: Audit systemd timer units
student_exec \
  --step-name "Audit systemd timer units" \
  --cmd "systemctl list-timers --all 2>/dev/null | head -n 10 || true" \
  --expect-exit-code 0

# Step 3: Write maintenance workflow status marker
student_exec \
  --step-name "Write maintenance workflow status marker" \
  --cmd "echo 'SYSTEMD_TIMER_MAINTENANCE_WORKFLOW_ACTIVE' > ~/admin-auto/maintenance_workflow.status" \
  --expect-exit-code 0

# Step 4: Verify maintenance_workflow.status content
student_exec \
  --step-name "Verify maintenance_workflow.status content" \
  --cmd "cat ~/admin-auto/maintenance_workflow.status" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SYSTEMD_TIMER_MAINTENANCE_WORKFLOW_ACTIVE"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Build Maintenance Workflow verified successfully."
