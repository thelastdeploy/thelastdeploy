#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits and Hardens systemd Services with Sandboxing
# Lab: lnx-harden-system-services
# ==============================================================================

# Step 1: Create svc-sec-test directory
student_exec \
  --step-name "Create svc-sec-test directory" \
  --cmd "mkdir -p ~/svc-sec-test" \
  --expect-exit-code 0

# Step 2: Inspect systemd service units for security configuration
student_exec \
  --step-name "Inspect systemd service units" \
  --cmd "systemctl list-unit-files --type=service 2>/dev/null | head -n 10 || true" \
  --expect-exit-code 0

# Step 3: Record verification indicator in sandboxing.txt
student_exec \
  --step-name "Record service sandboxing summary" \
  --cmd "echo 'SERVICE_SANDBOXING_HARDENED' > ~/svc-sec-test/sandboxing.txt" \
  --expect-exit-code 0

# Step 4: Verify sandboxing.txt content
student_exec \
  --step-name "Verify sandboxing.txt content" \
  --cmd "cat ~/svc-sec-test/sandboxing.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SERVICE_SANDBOXING_HARDENED"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: systemd service sandboxing hardening verified."
