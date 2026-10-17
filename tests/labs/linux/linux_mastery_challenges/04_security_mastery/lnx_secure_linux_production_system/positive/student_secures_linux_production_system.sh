#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Secures Linux Production System
# Lab: lnx-secure-linux-production-system
# ==============================================================================

# Step 1: Ensure mastery-sec directory exists
student_exec \
  --step-name "Ensure mastery-sec directory exists" \
  --cmd "mkdir -p ~/mastery-sec" \
  --expect-exit-code 0

# Step 2: Audit SSH and firewall status
student_exec \
  --step-name "Audit SSH and firewall status" \
  --cmd "ss -tlpn 2>/dev/null | grep -E '22|ssh' || true && iptables -L -n 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write security mastery marker
student_exec \
  --step-name "Write security mastery marker" \
  --cmd "echo 'PRODUCTION_SYSTEM_SECURITY_MASTERED' > ~/mastery-sec/security_mastery.conf" \
  --expect-exit-code 0

# Step 4: Verify security_mastery.conf content
student_exec \
  --step-name "Verify security_mastery.conf content" \
  --cmd "cat ~/mastery-sec/security_mastery.conf" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PRODUCTION_SYSTEM_SECURITY_MASTERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Secure Linux Production System verified successfully."
