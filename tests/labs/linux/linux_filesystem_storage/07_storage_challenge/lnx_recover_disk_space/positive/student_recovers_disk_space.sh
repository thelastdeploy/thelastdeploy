#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Recover disk space by clearing stale log archives
# Module: linux-filesystem-storage
# Section: 07-storage-challenge
# Lab ID: lnx-recover-disk-space
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-recover-disk-space"

# Step 1: Student inspects the storage challenge directory
student_exec "ls -lh ~/storage-challenge" \
    --desc "Student inspects active logs and archive folder" \
    --expect-exit 0 \
    --expect-stdout "active_app.log"

# Step 2: Student inspects stale archive contents
student_exec "ls -lh ~/storage-challenge/archives" \
    --desc "Student lists space-consuming archive files" \
    --expect-exit 0 \
    --expect-stdout "crash_2025.dump"

# Step 3: Student safely removes stale dump and tar.gz files
student_exec "rm -f ~/storage-challenge/archives/*.dump ~/storage-challenge/archives/*.tar.gz" \
    --desc "Student purges stale archive files" \
    --expect-exit 0

# Step 4: Student verifies that active service logs remain intact
student_exec "cat ~/storage-challenge/active_app.log" \
    --desc "Student confirms active app log is intact" \
    --expect-exit 0 \
    --expect-stdout "Active production log stream"

student_exec "cat ~/storage-challenge/active_service.log" \
    --desc "Student confirms active service log is intact" \
    --expect-exit 0 \
    --expect-stdout "Active service log stream"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Disk space recovered successfully while preserving active service logs!"
