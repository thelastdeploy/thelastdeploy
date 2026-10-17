#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Fixes DNS Configuration
# Lab: lnx-fix-dns-configuration
# ==============================================================================

# Step 1: Inspect resolv.conf configuration
student_exec \
  --step-name "Inspect resolv.conf" \
  --cmd "cat ~/net-test/resolv_fix/resolv.conf" \
  --expect-exit-code 0 \
  --expect-stdout-contains "0.0.0.0"

# Step 2: Fix nameserver IP to 8.8.8.8
student_exec \
  --step-name "Update nameserver to 8.8.8.8" \
  --cmd "sed -i 's/nameserver 0.0.0.0/nameserver 8.8.8.8/' ~/net-test/resolv_fix/resolv.conf" \
  --expect-exit-code 0

# Step 3: Verify content of resolv.conf
student_exec \
  --step-name "Verify resolv.conf content" \
  --cmd "cat ~/net-test/resolv_fix/resolv.conf" \
  --expect-exit-code 0 \
  --expect-stdout-contains "nameserver 8.8.8.8"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUCCESS: DNS configuration repaired successfully."
