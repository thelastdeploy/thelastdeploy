#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Failing Storage & Filesystem System
# Lab: lnx-recover-failing-storage-system
# ==============================================================================

# Step 1: Ensure storage-outage-test directory exists
student_exec \
  --step-name "Ensure storage-outage-test directory exists" \
  --cmd "mkdir -p ~/storage-outage-test" \
  --expect-exit-code 0

# Step 2: Check storage and mount status
student_exec \
  --step-name "Check storage and mount status" \
  --cmd "df -h | head -n 5 && mount | head -n 5" \
  --expect-exit-code 0

# Step 3: Write storage recovery proof marker
student_exec \
  --step-name "Write storage recovery proof marker" \
  --cmd "echo 'STORAGE_SYSTEM_RECOVERED' > ~/storage-outage-test/storage_recovered.txt" \
  --expect-exit-code 0

# Step 4: Verify storage_recovered.txt content
student_exec \
  --step-name "Verify storage_recovered.txt content" \
  --cmd "cat ~/storage-outage-test/storage_recovered.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "STORAGE_SYSTEM_RECOVERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Failing storage system recovery verified."
