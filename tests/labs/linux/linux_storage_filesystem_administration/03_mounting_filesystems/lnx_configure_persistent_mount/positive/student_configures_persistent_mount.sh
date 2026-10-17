#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Configures Persistent Mounts in Fstab
# Lab: lnx-configure-persistent-mount
# ==============================================================================

# Step 1: Ensure storage-test directory and mock_fstab exist
student_exec \
  --step-name "Ensure storage-test directory exists" \
  --cmd "mkdir -p ~/storage-test && touch ~/storage-test/mock_fstab" \
  --expect-exit-code 0

# Step 2: Add persistent mount entry for UUID=a1b2c3d4-1234-5678-90ab-cdef12345678 to mock_fstab
student_exec \
  --step-name "Append persistent mount entry to mock_fstab" \
  --cmd "echo 'UUID=a1b2c3d4-1234-5678-90ab-cdef12345678 /mnt/data ext4 defaults 0 2' >> ~/storage-test/mock_fstab" \
  --expect-exit-code 0

# Step 3: Verify mock_fstab contents
student_exec \
  --step-name "Verify mock_fstab content" \
  --cmd "cat ~/storage-test/mock_fstab" \
  --expect-exit-code 0 \
  --expect-stdout-contains "UUID=a1b2c3d4-1234-5678-90ab-cdef12345678"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Persistent fstab mount configuration verified."
