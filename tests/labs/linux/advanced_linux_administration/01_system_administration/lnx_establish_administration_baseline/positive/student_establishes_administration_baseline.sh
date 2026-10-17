#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Establishes Administration Baseline
# Lab: lnx-establish-administration-baseline
# ==============================================================================

# Step 1: Ensure sysadmin-audit directory exists
student_exec \
  --step-name "Ensure sysadmin-audit directory exists" \
  --cmd "mkdir -p ~/sysadmin-audit" \
  --expect-exit-code 0

# Step 2: Audit system sysctl settings and resource limits
student_exec \
  --step-name "Audit system sysctl settings and resource limits" \
  --cmd "sysctl fs.file-max 2>/dev/null || true && ulimit -a 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write admin baseline marker
student_exec \
  --step-name "Write admin baseline marker" \
  --cmd "echo 'OPERATIONAL_ADMINISTRATION_BASELINE_ESTABLISHED' > ~/sysadmin-audit/admin_baseline.conf" \
  --expect-exit-code 0

# Step 4: Verify admin_baseline.conf content
student_exec \
  --step-name "Verify admin_baseline.conf content" \
  --cmd "cat ~/sysadmin-audit/admin_baseline.conf" \
  --expect-exit-code 0 \
  --expect-stdout-contains "OPERATIONAL_ADMINISTRATION_BASELINE_ESTABLISHED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Establish Administration Baseline verified successfully."
