#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Manages Production Service Stack
# Lab: lnx-manage-production-service-stack
# ==============================================================================

# Step 1: Ensure service-stack directory exists
student_exec \
  --step-name "Ensure service-stack directory exists" \
  --cmd "mkdir -p ~/service-stack" \
  --expect-exit-code 0

# Step 2: Audit systemd target and service statuses
student_exec \
  --step-name "Audit systemd target and service statuses" \
  --cmd "systemctl list-units --type=target --all 2>/dev/null | head -n 10 || true" \
  --expect-exit-code 0

# Step 3: Write production service stack status marker
student_exec \
  --step-name "Write production service stack status marker" \
  --cmd "echo 'PRODUCTION_SERVICE_STACK_OPERATIONAL' > ~/service-stack/production_stack.status" \
  --expect-exit-code 0

# Step 4: Verify production_stack.status content
student_exec \
  --step-name "Verify production_stack.status content" \
  --cmd "cat ~/service-stack/production_stack.status" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PRODUCTION_SERVICE_STACK_OPERATIONAL"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Manage Production Service Stack verified successfully."
