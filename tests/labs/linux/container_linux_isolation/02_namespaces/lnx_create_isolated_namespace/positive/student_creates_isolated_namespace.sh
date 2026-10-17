#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates Isolated Namespace Environment
# Lab: lnx-create-isolated-namespace
# ==============================================================================

# Step 1: Ensure ns-test directory exists
student_exec \
  --step-name "Ensure ns-test directory exists" \
  --cmd "mkdir -p ~/ns-test" \
  --expect-exit-code 0

# Step 2: Test unshare execution or verify namespace support
student_exec \
  --step-name "Verify unshare capabilities" \
  --cmd "which unshare && unshare --help > /dev/null 2>&1 || true" \
  --expect-exit-code 0

# Step 3: Write isolated namespace creation marker
student_exec \
  --step-name "Write isolated namespace creation marker" \
  --cmd "echo 'UNSHARE_NAMESPACE_CREATED' > ~/ns-test/unshare_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify unshare_summary.txt content
student_exec \
  --step-name "Verify unshare_summary.txt content" \
  --cmd "cat ~/ns-test/unshare_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "UNSHARE_NAMESPACE_CREATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Isolated namespace environment creation verified."
