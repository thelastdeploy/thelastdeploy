#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Controls Network Traffic Shaping with tc
# Lab: lnx-control-network-traffic
# ==============================================================================

# Step 1: Ensure tc-test directory exists
student_exec \
  --step-name "Ensure tc-test directory exists" \
  --cmd "mkdir -p ~/tc-test" \
  --expect-exit-code 0

# Step 2: Inspect traffic control queuing disciplines via tc qdisc show
student_exec \
  --step-name "Inspect traffic control queuing disciplines" \
  --cmd "tc qdisc show" \
  --expect-exit-code 0

# Step 3: Write inspection summary
student_exec \
  --step-name "Write tc summary" \
  --cmd "echo 'TC_QDISC_INSPECTED' > ~/tc-test/tc_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify content of tc_summary.txt
student_exec \
  --step-name "Verify tc_summary.txt content" \
  --cmd "cat ~/tc-test/tc_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "TC_QDISC_INSPECTED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Traffic control inspection verified."
