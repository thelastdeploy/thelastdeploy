#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Plans Server Storage
# Lab: lnx-plan-server-storage
# ==============================================================================

# Step 1: Ensure storage-admin directory exists
student_exec \
  --step-name "Ensure storage-admin directory exists" \
  --cmd "mkdir -p ~/storage-admin" \
  --expect-exit-code 0

# Step 2: Audit block storage devices
student_exec \
  --step-name "Audit block storage devices" \
  --cmd "lsblk && df -h" \
  --expect-exit-code 0

# Step 3: Write storage plan marker
student_exec \
  --step-name "Write storage plan marker" \
  --cmd "echo 'ENTERPRISE_STORAGE_LAYOUT_PLANNED' > ~/storage-admin/storage_plan.conf" \
  --expect-exit-code 0

# Step 4: Verify storage_plan.conf content
student_exec \
  --step-name "Verify storage_plan.conf content" \
  --cmd "cat ~/storage-admin/storage_plan.conf" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ENTERPRISE_STORAGE_LAYOUT_PLANNED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Plan Server Storage verified successfully."
