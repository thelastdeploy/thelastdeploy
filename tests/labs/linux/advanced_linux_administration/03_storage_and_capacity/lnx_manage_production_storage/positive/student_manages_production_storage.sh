#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Manages Production Storage
# Lab: lnx-manage-production-storage
# ==============================================================================

# Step 1: Ensure storage-admin directory exists
student_exec \
  --step-name "Ensure storage-admin directory exists" \
  --cmd "mkdir -p ~/storage-admin" \
  --expect-exit-code 0

# Step 2: Audit LVM volumes and filesystems
student_exec \
  --step-name "Audit LVM volumes and filesystems" \
  --cmd "vgs 2>/dev/null || true && lvs 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write LVM expansion log marker
student_exec \
  --step-name "Write LVM expansion log marker" \
  --cmd "echo 'LIVE_PRODUCTION_STORAGE_EXPANDED_SUCCESSFULLY' > ~/storage-admin/lvm_expansion.log" \
  --expect-exit-code 0

# Step 4: Verify lvm_expansion.log content
student_exec \
  --step-name "Verify lvm_expansion.log content" \
  --cmd "cat ~/storage-admin/lvm_expansion.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "LIVE_PRODUCTION_STORAGE_EXPANDED_SUCCESSFULLY"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Manage Production Storage verified successfully."
