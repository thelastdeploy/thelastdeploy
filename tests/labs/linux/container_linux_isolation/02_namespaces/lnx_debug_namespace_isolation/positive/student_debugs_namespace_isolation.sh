#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Debugs Namespace Isolation Issues
# Lab: lnx-debug-namespace-isolation
# ==============================================================================

# Step 1: Ensure ns-test directory exists
student_exec \
  --step-name "Ensure ns-test directory exists" \
  --cmd "mkdir -p ~/ns-test" \
  --expect-exit-code 0

# Step 2: Troubleshoot namespace isolation diagnostics
student_exec \
  --step-name "Troubleshoot namespace isolation diagnostics" \
  --cmd "lsns 2>/dev/null || ip netns list 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write namespace isolation debug marker
student_exec \
  --step-name "Write namespace isolation debug marker" \
  --cmd "echo 'NAMESPACE_ISOLATION_DEBUGGED' > ~/ns-test/ns_debug.txt" \
  --expect-exit-code 0

# Step 4: Verify ns_debug.txt content
student_exec \
  --step-name "Verify ns_debug.txt content" \
  --cmd "cat ~/ns-test/ns_debug.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "NAMESPACE_ISOLATION_DEBUGGED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Namespace isolation debugging verified."
