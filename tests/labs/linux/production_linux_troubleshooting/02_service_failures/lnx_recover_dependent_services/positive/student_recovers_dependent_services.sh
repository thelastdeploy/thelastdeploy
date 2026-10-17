#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Dependent Service Stack
# Lab: lnx-recover-dependent-services
# ==============================================================================

# Step 1: Ensure svc-outage-test directory exists
student_exec \
  --step-name "Ensure svc-outage-test directory exists" \
  --cmd "mkdir -p ~/svc-outage-test" \
  --expect-exit-code 0

# Step 2: Trace unit dependencies
student_exec \
  --step-name "Trace unit dependencies" \
  --cmd "systemctl list-units --type=service --state=running | head -n 10 || true" \
  --expect-exit-code 0

# Step 3: Write stack recovery marker
student_exec \
  --step-name "Write stack recovery marker" \
  --cmd "echo 'DEPENDENT_STACK_RECOVERED' > ~/svc-outage-test/stack_recovery.txt" \
  --expect-exit-code 0

# Step 4: Verify stack_recovery.txt content
student_exec \
  --step-name "Verify stack_recovery.txt content" \
  --cmd "cat ~/svc-outage-test/stack_recovery.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "DEPENDENT_STACK_RECOVERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Dependent service stack recovery verified."
