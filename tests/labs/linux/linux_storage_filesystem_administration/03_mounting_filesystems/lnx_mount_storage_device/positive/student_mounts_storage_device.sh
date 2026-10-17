#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Mounts and Unmounts Storage Devices
# Lab: lnx-mount-storage-device
# ==============================================================================

# Step 1: Ensure storage-test directory exists
student_exec \
  --step-name "Ensure storage-test directory exists" \
  --cmd "mkdir -p ~/storage-test" \
  --expect-exit-code 0

# Step 2: Create mount_cmd.sh with mount and umount commands
student_exec \
  --step-name "Create executable mount_cmd.sh" \
  --cmd "cat << 'EOF' > ~/storage-test/mount_cmd.sh
#!/bin/bash
mount /dev/sdb1 /mnt/appdata
umount /mnt/appdata
EOF
chmod +x ~/storage-test/mount_cmd.sh" \
  --expect-exit-code 0

# Step 3: Verify mount_cmd.sh is executable and contains commands
student_exec \
  --step-name "Verify mount_cmd.sh contents and permissions" \
  --cmd "ls -l ~/storage-test/mount_cmd.sh && cat ~/storage-test/mount_cmd.sh" \
  --expect-exit-code 0 \
  --expect-stdout-contains "mount /dev/sdb1 /mnt/appdata"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Mount and unmount command syntax verified."
