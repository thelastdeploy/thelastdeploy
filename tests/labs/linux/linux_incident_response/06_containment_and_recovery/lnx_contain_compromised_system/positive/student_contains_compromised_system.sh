#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Contains Compromised System Safely
# Lab: lnx-contain-compromised-system
# ==============================================================================

# Step 1: Ensure recovery-test directory exists
student_exec \
  --step-name "Ensure recovery-test directory exists" \
  --cmd "mkdir -p ~/recovery-test" \
  --expect-exit-code 0

# Step 2: Audit iptables firewall rules
student_exec \
  --step-name "Audit iptables firewall rules" \
  --cmd "iptables -L -n 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write containment summary marker
student_exec \
  --step-name "Write containment summary marker" \
  --cmd "echo 'COMPROMISED_SYSTEM_CONTAINED' > ~/recovery-test/containment_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify containment_summary.txt content
student_exec \
  --step-name "Verify containment_summary.txt content" \
  --cmd "cat ~/recovery-test/containment_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "COMPROMISED_SYSTEM_CONTAINED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Compromised system containment verified."
