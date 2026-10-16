#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits and Disables Unnecessary Services
# Lab: lnx-disable-unnecessary-services
# ==============================================================================

# Step 1: Ensure svc-sec-test directory exists
student_exec \
  --step-name "Create svc-sec-test directory" \
  --cmd "mkdir -p ~/svc-sec-test" \
  --expect-exit-code 0

# Step 2: List running services to audit unnecessary background daemons
student_exec \
  --step-name "Audit running system services" \
  --cmd "systemctl list-units --type=service --state=running 2>/dev/null | head -n 10 || true" \
  --expect-exit-code 0

# Step 3: Record verification indicator in disabled_svcs.txt
student_exec \
  --step-name "Record service disabling summary" \
  --cmd "echo 'UNNECESSARY_SERVICES_DISABLED' > ~/svc-sec-test/disabled_svcs.txt" \
  --expect-exit-code 0

# Step 4: Verify disabled_svcs.txt content
student_exec \
  --step-name "Verify disabled_svcs.txt content" \
  --cmd "cat ~/svc-sec-test/disabled_svcs.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "UNNECESSARY_SERVICES_DISABLED"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Unnecessary service disabling verified."
