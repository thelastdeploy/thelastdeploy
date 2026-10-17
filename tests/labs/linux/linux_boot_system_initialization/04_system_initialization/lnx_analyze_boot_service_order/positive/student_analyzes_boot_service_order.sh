#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Analyzes Boot Service Startup Order
# Lab: lnx-analyze-boot-service-order
# ==============================================================================

# Step 1: Ensure sys-init-test directory exists
student_exec \
  --step-name "Ensure sys-init-test directory exists" \
  --cmd "mkdir -p ~/sys-init-test" \
  --expect-exit-code 0

# Step 2: Write summary line to critical_chain.txt
student_exec \
  --step-name "Write critical chain summary" \
  --cmd "echo 'CRITICAL_CHAIN_INSPECTED' > ~/sys-init-test/critical_chain.txt" \
  --expect-exit-code 0

# Step 3: Verify content of critical_chain.txt
student_exec \
  --step-name "Verify critical_chain.txt content" \
  --cmd "cat ~/sys-init-test/critical_chain.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CRITICAL_CHAIN_INSPECTED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Boot service startup order analysis verified."
