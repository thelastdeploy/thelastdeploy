#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Production Incident via Log Correlation
# Lab: lnx-trace-production-incident
# ==============================================================================

# Step 1: Ensure incident-investigation directory exists
student_exec \
  --step-name "Ensure incident-investigation directory exists" \
  --cmd "mkdir -p ~/incident-investigation/logs" \
  --expect-exit-code 0

# Step 2: Write incident post-mortem report to incident_report.txt
student_exec \
  --step-name "Generate incident report" \
  --cmd "cat << 'EOF' > ~/incident-investigation/incident_report.txt
INCIDENT_TIMESTAMP: 2026-09-20 03:14:22
FAILED_SERVICE: order-api.service
ROOT_CAUSE: OUT_OF_MEMORY
EOF" \
  --expect-exit-code 0

# Step 3: Verify content of incident_report.txt
student_exec \
  --step-name "Verify incident_report.txt content" \
  --cmd "cat ~/incident-investigation/incident_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "FAILED_SERVICE: order-api.service"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Production incident logging investigation capstone verified."
