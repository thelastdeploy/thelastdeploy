#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Configures Policy Routing Rules
# Lab: lnx-configure-policy-routing
# ==============================================================================

# Step 1: Ensure route-test directory exists
student_exec \
  --step-name "Ensure route-test directory exists" \
  --cmd "mkdir -p ~/route-test" \
  --expect-exit-code 0

# Step 2: Inspect routing rules via ip rule show
student_exec \
  --step-name "Inspect policy routing rules" \
  --cmd "ip rule show" \
  --expect-exit-code 0

# Step 3: Write rules inspection summary
student_exec \
  --step-name "Write rules summary" \
  --cmd "echo 'POLICY_ROUTING_INSPECTED' > ~/route-test/rules_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify content of rules_summary.txt
student_exec \
  --step-name "Verify rules_summary.txt content" \
  --cmd "cat ~/route-test/rules_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "POLICY_ROUTING_INSPECTED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Policy routing rules configuration verified."
