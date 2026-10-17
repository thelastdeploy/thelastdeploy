#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Restores Missing Storage
# Lab: lnx-restore-missing-storage
# ==============================================================================

# Step 1: Verify storage-challenge environment setup
student_exec \
  --step-name "Verify storage-challenge setup" \
  --cmd "ls -la ~/storage-challenge/app && ls -ld ~/storage-challenge/mounts/app_data" \
  --expect-exit-code 0

# Step 2: Update fstab_config to point to correct mount path
student_exec \
  --step-name "Update mount path in fstab_config" \
  --cmd "sed -i \"s|/mnt/wrong_path|\$HOME/storage-challenge/mounts/app_data|\" ~/storage-challenge/app/fstab_config" \
  --expect-exit-code 0

# Step 3: Set permissions on app_data to 775
student_exec \
  --step-name "Set directory permissions to 775" \
  --cmd "chmod 775 ~/storage-challenge/mounts/app_data" \
  --expect-exit-code 0

# Step 4: Update status.txt to mark status OK
student_exec \
  --step-name "Update status to OK" \
  --cmd "echo 'STATUS: OK' > ~/storage-challenge/app/status.txt" \
  --expect-exit-code 0

# Step 5: Verify configuration and status
student_exec \
  --step-name "Verify configuration and permissions" \
  --cmd "stat -c '%a' ~/storage-challenge/mounts/app_data && cat ~/storage-challenge/app/status.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "775"

# Step 6: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Storage volume restored and app status marked OK."
