#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Firewall Rules and Packet Chains
# Lab: lnx-inspect-firewall-rules
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-inspect-firewall-rules"

# Step 1: Ensure fw-test directory exists
student_exec \
  --step-name "Ensure fw-test directory exists" \
  --cmd "mkdir -p ~/fw-test" \
  --expect-exit-code 0

# Step 2: Inspect firewall rule chains via iptables
student_exec \
  --step-name "Inspect firewall chains" \
  --cmd "iptables -L -n 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write inspection summary
student_exec \
  --step-name "Write firewall summary" \
  --cmd "echo 'FIREWALL_CHAINS_INSPECTED' > ~/fw-test/fw_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify content of fw_summary.txt
student_exec \
  --step-name "Verify fw_summary.txt content" \
  --cmd "cat ~/fw-test/fw_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "FIREWALL_CHAINS_INSPECTED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Firewall rules inspection verified."
