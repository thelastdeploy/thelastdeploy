#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Service Startup by Fixing ExecStart
# Lab: lnx-recover-service-startup
# ==============================================================================

# Step 1: Repair ExecStart in broken.service and save to fixed.service
student_exec \
  --step-name "Repair ExecStart directive" \
  --cmd "sed 's|/bin/missing_binary|/bin/echo Service Restored|' ~/fail-test/broken.service > ~/fail-test/fixed.service" \
  --expect-exit-code 0

# Step 2: Verify fixed.service file exists and has valid ExecStart
student_exec \
  --step-name "Verify fixed.service content" \
  --cmd "cat ~/fail-test/fixed.service" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ExecStart=/bin/echo"

# Step 3: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Service startup recovery verified."
