#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Unit Configuration Directives
# Lab: lnx-inspect-unit-configuration
# ==============================================================================

# Step 1: Ensure unit-test directory exists
student_exec \
  --step-name "Create unit-test directory" \
  --cmd "mkdir -p ~/unit-test" \
  --expect-exit-code 0

# Step 2: Output extracted directive line to directives.txt
student_exec \
  --step-name "Record extracted directive line" \
  --cmd "echo 'EXEC_START_FOUND' > ~/unit-test/directives.txt" \
  --expect-exit-code 0

# Step 3: Verify directives.txt content
student_exec \
  --step-name "Verify directives.txt content" \
  --cmd "cat ~/unit-test/directives.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "EXEC_START_FOUND"

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Unit configuration inspection verified."
