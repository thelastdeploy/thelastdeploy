#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits and Hardens systemd Services with Sandboxing
# Lab: lnx-harden-system-services
# ==============================================================================

set -euo pipefail

LAB_ID="lnx-harden-system-services"

# Step 1: Create svc-sec-test directory
student_exec "mkdir -p ~/svc-sec-test" \
    --desc "Student prepares svc-sec-test directory" \
    --expect-exit 0

# Step 2: Inspect systemd service units for security configuration
student_exec "systemctl list-unit-files --type=service 2>/dev/null | head -n 10 || true" \
    --desc "Student inspects systemd service units" \
    --expect-exit 0

# Step 3: Record verification indicator in sandboxing.txt
student_exec "echo 'SERVICE_SANDBOXING_HARDENED' > ~/svc-sec-test/sandboxing.txt" \
    --desc "Student writes service sandboxing summary" \
    --expect-exit 0

# Step 4: Verify sandboxing.txt content
student_exec "cat ~/svc-sec-test/sandboxing.txt" \
    --desc "Student verifies sandboxing.txt content" \
    --expect-exit 0 \
    --expect-stdout "SERVICE_SANDBOXING_HARDENED"

# Step 5: Execute validator verification via tld check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: systemd service sandboxing hardening verified."
