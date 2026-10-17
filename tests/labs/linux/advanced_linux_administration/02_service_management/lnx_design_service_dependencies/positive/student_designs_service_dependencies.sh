#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Designs Service Dependencies
# Lab: lnx-design-service-dependencies
# ==============================================================================

# Step 1: Ensure service-stack directory exists
student_exec \
  --step-name "Ensure service-stack directory exists" \
  --cmd "mkdir -p ~/service-stack" \
  --expect-exit-code 0

# Step 2: Audit systemd service dependencies
student_exec \
  --step-name "Audit systemd service dependencies" \
  --cmd "systemctl list-dependencies 2>/dev/null | head -n 10 || true" \
  --expect-exit-code 0

# Step 3: Write service dependencies marker
student_exec \
  --step-name "Write service dependencies marker" \
  --cmd "echo 'SYSTEMD_SERVICE_DEPENDENCIES_CONFIGURED' > ~/service-stack/service_dependencies.log" \
  --expect-exit-code 0

# Step 4: Verify service_dependencies.log content
student_exec \
  --step-name "Verify service_dependencies.log content" \
  --cmd "cat ~/service-stack/service_dependencies.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SYSTEMD_SERVICE_DEPENDENCIES_CONFIGURED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Design Service Dependencies verified successfully."
