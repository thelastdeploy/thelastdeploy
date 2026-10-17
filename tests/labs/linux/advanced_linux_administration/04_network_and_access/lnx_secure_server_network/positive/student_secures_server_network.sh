#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Secures Server Network
# Lab: lnx-secure-server-network
# ==============================================================================

# Step 1: Ensure net-sec directory exists
student_exec \
  --step-name "Ensure net-sec directory exists" \
  --cmd "mkdir -p ~/net-sec" \
  --expect-exit-code 0

# Step 2: Audit firewall and network interfaces
student_exec \
  --step-name "Audit firewall and network interfaces" \
  --cmd "ip link show && iptables -L -n 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write firewall hardening marker
student_exec \
  --step-name "Write firewall hardening marker" \
  --cmd "echo 'STATEFUL_FIREWALL_RULES_CONFIGURED' > ~/net-sec/firewall_hardening.log" \
  --expect-exit-code 0

# Step 4: Verify firewall_hardening.log content
student_exec \
  --step-name "Verify firewall_hardening.log content" \
  --cmd "cat ~/net-sec/firewall_hardening.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "STATEFUL_FIREWALL_RULES_CONFIGURED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Secure Server Network verified successfully."
