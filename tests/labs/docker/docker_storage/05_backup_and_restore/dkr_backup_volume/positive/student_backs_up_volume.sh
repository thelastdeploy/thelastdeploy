#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Backs Up Volume
# Lab: dkr-backup-volume
# ==============================================================================

# Step 1: Ensure backup directory exists
student_exec \
  --step-name "Ensure ~/docker-backup directory exists" \
  --cmd "mkdir -p ~/docker-backup" \
  --expect-exit-code 0

# Step 2: Run temporary container to archive volume contents
student_exec \
  --step-name "Archive volume contents using temporary container" \
  --cmd "docker run --rm -v prod-db-vol:/volume -v \"\$HOME/docker-backup:/backup\" alpine tar cvf /backup/backup.tar -C /volume ." \
  --expect-exit-code 0

# Step 3: Verify backup archive contents
student_exec \
  --step-name "Verify backup archive contents" \
  --cmd "tar -tf ~/docker-backup/backup.tar" \
  --expect-exit-code 0 \
  --expect-stdout-contains "important_backup_data.txt"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully verified volume backup tarball."
