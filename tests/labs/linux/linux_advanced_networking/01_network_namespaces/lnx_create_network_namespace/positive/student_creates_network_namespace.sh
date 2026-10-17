#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates and Inspects Network Namespace
# Lab: lnx-create-network-namespace
# ==============================================================================

# Step 1: Ensure netns-test directory exists
student_exec \
  --step-name "Ensure netns-test directory exists" \
  --cmd "mkdir -p ~/netns-test" \
  --expect-exit-code 0

# Step 2: Inspect network namespaces
student_exec \
  --step-name "Inspect network namespaces via ip netns list" \
  --cmd "ip netns list" \
  --expect-exit-code 0

# Step 3: Write inspection log marker
student_exec \
  --step-name "Write inspection log marker" \
  --cmd "echo 'NETNS_INSPECTED' > ~/netns-test/ns_list.txt" \
  --expect-exit-code 0

# Step 4: Verify content of ns_list.txt
student_exec \
  --step-name "Verify ns_list.txt content" \
  --cmd "cat ~/netns-test/ns_list.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "NETNS_INSPECTED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Network namespace inspection verified."
