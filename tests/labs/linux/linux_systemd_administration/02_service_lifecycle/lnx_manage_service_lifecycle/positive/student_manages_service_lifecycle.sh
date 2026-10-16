#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Manages Service Lifecycle and Records Active Status
# Lab: lnx-manage-service-lifecycle
# ==============================================================================

# Step 1: Ensure service-test directory exists
student_exec \
  --step-name "Create service-test directory" \
  --cmd "mkdir -p ~/service-test" \
  --expect-exit-code 0

# Step 2: Record active service status into lifecycle_summary.txt
student_exec \
  --step-name "Record service active status" \
  --cmd "echo 'SERVICE_STATUS: active' > ~/service-test/lifecycle_summary.txt" \
  --expect-exit-code 0

# Step 3: Verify lifecycle_summary.txt content
student_exec \
  --step-name "Verify lifecycle_summary.txt content" \
  --cmd "cat ~/service-test/lifecycle_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SERVICE_STATUS: active"

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Service lifecycle summary verified."
