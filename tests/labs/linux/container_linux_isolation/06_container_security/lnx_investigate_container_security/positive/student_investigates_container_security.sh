#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Investigates Container Security Capabilities and Seccomp
# Lab: lnx-investigate-container-security
# ==============================================================================

# Step 1: Ensure container-sec-test directory exists
student_exec \
  --step-name "Ensure container-sec-test directory exists" \
  --cmd "mkdir -p ~/container-sec-test" \
  --expect-exit-code 0

# Step 2: Inspect process capability status
student_exec \
  --step-name "Inspect process capability status" \
  --cmd "grep -i 'Cap' /proc/self/status 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write container capabilities investigation marker
student_exec \
  --step-name "Write container capabilities investigation marker" \
  --cmd "echo 'CONTAINER_CAPABILITIES_INVESTIGATED' > ~/container-sec-test/sec_caps.txt" \
  --expect-exit-code 0

# Step 4: Verify sec_caps.txt content
student_exec \
  --step-name "Verify sec_caps.txt content" \
  --cmd "cat ~/container-sec-test/sec_caps.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CONTAINER_CAPABILITIES_INVESTIGATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Container security capabilities and Seccomp investigation verified."
