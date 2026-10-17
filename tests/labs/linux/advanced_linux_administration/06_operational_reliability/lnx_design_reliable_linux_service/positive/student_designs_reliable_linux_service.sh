#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Designs Reliable Linux Service
# Lab: lnx-design-reliable-linux-service
# ==============================================================================

# Step 1: Ensure reliability directory exists
student_exec \
  --step-name "Ensure reliability directory exists" \
  --cmd "mkdir -p ~/reliability" \
  --expect-exit-code 0

# Step 2: Audit systemd service status
student_exec \
  --step-name "Audit systemd service status" \
  --cmd "systemctl is-system-running 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write reliability design log marker
student_exec \
  --step-name "Write reliability design log marker" \
  --cmd "echo 'OPERATIONAL_RELIABILITY_HEALTHCHECK_ACTIVE' > ~/reliability/reliability_design.log" \
  --expect-exit-code 0

# Step 4: Verify reliability_design.log content
student_exec \
  --step-name "Verify reliability_design.log content" \
  --cmd "cat ~/reliability/reliability_design.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "OPERATIONAL_RELIABILITY_HEALTHCHECK_ACTIVE"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Design Reliable Linux Service verified successfully."
