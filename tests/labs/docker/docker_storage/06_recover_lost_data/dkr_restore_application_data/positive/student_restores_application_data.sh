#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Restores Application Data
# Lab: dkr-restore-application-data
# ==============================================================================

# Step 1: Run temporary container to extract backup tarball into destination volume
student_exec \
  --step-name "Restore backup tarball into restored-db-vol" \
  --cmd "docker run --rm -v restored-db-vol:/volume -v \"\$HOME/docker-restore-source:/backup\" alpine tar xvf /backup/backup.tar -C /volume" \
  --expect-exit-code 0

# Step 2: Verify restored file content inside volume
student_exec \
  --step-name "Verify db_state.json content inside restored volume" \
  --cmd "docker run --rm -v restored-db-vol:/data alpine cat /data/db_state.json" \
  --expect-exit-code 0 \
  --expect-stdout-contains "restored"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully verified application data restoration."
