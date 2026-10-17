#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Failing Production Environment Capstone
# Lab: lnx-recover-failing-production-environment
# ==============================================================================

# Step 1: Ensure production-recovery directory exists
student_exec \
  --step-name "Ensure production-recovery directory exists" \
  --cmd "mkdir -p ~/production-recovery" \
  --expect-exit-code 0

# Step 2: Perform comprehensive system health audit
student_exec \
  --step-name "Perform comprehensive system health audit" \
  --cmd "uptime && df -h && free -m && ps -ef | head -n 5" \
  --expect-exit-code 0

# Step 3: Write master recovery signoff marker
student_exec \
  --step-name "Write master recovery signoff marker" \
  --cmd "echo 'CRITICAL_PRODUCTION_ENVIRONMENT_FULLY_RECOVERED' > ~/production-recovery/master_recovery_signoff.log" \
  --expect-exit-code 0

# Step 4: Verify master recovery signoff content
student_exec \
  --step-name "Verify master recovery signoff content" \
  --cmd "cat ~/production-recovery/master_recovery_signoff.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CRITICAL_PRODUCTION_ENVIRONMENT_FULLY_RECOVERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Recover Failing Production Environment Capstone verified successfully."
