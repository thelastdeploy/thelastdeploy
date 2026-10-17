#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Debugs Service Connectivity
# Lab: lnx-debug-service-connectivity
# ==============================================================================

# Step 1: Inspect app configuration
student_exec \
  --step-name "Inspect app conf" \
  --cmd "cat ~/net-test/service_debug/app.conf" \
  --expect-exit-code 0 \
  --expect-stdout-contains "127.0.0.1"

# Step 2: Update BIND_ADDRESS to 0.0.0.0
student_exec \
  --step-name "Update bind address to 0.0.0.0" \
  --cmd "sed -i 's/BIND_ADDRESS=\"127.0.0.1\"/BIND_ADDRESS=\"0.0.0.0\"/' ~/net-test/service_debug/app.conf" \
  --expect-exit-code 0

# Step 3: Verify content of app.conf
student_exec \
  --step-name "Verify app.conf content" \
  --cmd "cat ~/net-test/service_debug/app.conf" \
  --expect-exit-code 0 \
  --expect-stdout-contains 'BIND_ADDRESS="0.0.0.0"'

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUCCESS: Service binding configuration debugged successfully."
