#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Disk Partition Tables
# Lab: lnx-inspect-disk-partitions
# ==============================================================================

# Step 1: Ensure storage-test directory exists
student_exec \
  --step-name "Ensure storage-test directory exists" \
  --cmd "mkdir -p ~/storage-test" \
  --expect-exit-code 0

# Step 2: Inspect disk partition table or copy simulated fdisk dump to partition_info.txt
student_exec \
  --step-name "Save partition table layout" \
  --cmd "if [ -f ~/storage-test/fdisk_dump.txt ]; then
  cp ~/storage-test/fdisk_dump.txt ~/storage-test/partition_info.txt
else
  fdisk -l 2>/dev/null > ~/storage-test/partition_info.txt || true
fi" \
  --expect-exit-code 0

# Step 3: Verify partition_info.txt content
student_exec \
  --step-name "Verify partition_info.txt content" \
  --cmd "cat ~/storage-test/partition_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "/dev/sdb1"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Disk partition inspection verified."
