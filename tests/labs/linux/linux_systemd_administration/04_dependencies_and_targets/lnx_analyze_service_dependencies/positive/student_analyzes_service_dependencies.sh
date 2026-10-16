#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Analyzes Service Dependencies
# Lab: lnx-analyze-service-dependencies
# ==============================================================================

# Step 1: Ensure target-test directory exists
student_exec \
  --step-name "Create target-test directory" \
  --cmd "mkdir -p ~/target-test" \
  --expect-exit-code 0

# Step 2: Query multi-user.target dependencies and write verification line
student_exec \
  --step-name "Analyze unit dependencies" \
  --cmd "systemctl list-dependencies multi-user.target > /dev/null 2>&1 || true
echo 'DEPENDENCIES_ANALYZED' > ~/target-test/deps.txt" \
  --expect-exit-code 0

# Step 3: Verify deps.txt content
student_exec \
  --step-name "Verify deps.txt content" \
  --cmd "cat ~/target-test/deps.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "DEPENDENCIES_ANALYZED"

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Service dependency analysis verified."
