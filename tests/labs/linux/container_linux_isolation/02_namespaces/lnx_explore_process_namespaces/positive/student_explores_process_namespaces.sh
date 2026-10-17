#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Explores Linux Namespace Types
# Lab: lnx-explore-process-namespaces
# ==============================================================================

# Step 1: Ensure ns-test directory exists
student_exec \
  --step-name "Ensure ns-test directory exists" \
  --cmd "mkdir -p ~/ns-test" \
  --expect-exit-code 0

# Step 2: Inspect process namespace entries in /proc/self/ns
student_exec \
  --step-name "Inspect process namespace entries in /proc/self/ns" \
  --cmd "ls -la /proc/self/ns/ 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write namespace exploration marker
student_exec \
  --step-name "Write namespace exploration marker" \
  --cmd "echo 'NAMESPACE_TYPES_EXPLORED' > ~/ns-test/ns_types.txt" \
  --expect-exit-code 0

# Step 4: Verify ns_types.txt content
student_exec \
  --step-name "Verify ns_types.txt content" \
  --cmd "cat ~/ns-test/ns_types.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "NAMESPACE_TYPES_EXPLORED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Linux namespace types exploration verified."
