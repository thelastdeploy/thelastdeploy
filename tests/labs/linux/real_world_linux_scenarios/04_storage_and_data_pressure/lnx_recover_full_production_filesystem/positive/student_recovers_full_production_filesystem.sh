#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Full Production Filesystem
# Lab: lnx-recover-full-production-filesystem
# ==============================================================================

# Step 1: Ensure storage-crisis directory exists
student_exec \
  --step-name "Ensure storage-crisis directory exists" \
  --cmd "mkdir -p ~/storage-crisis" \
  --expect-exit-code 0

# Step 2: Check filesystem usage and unlinked open file descriptors
student_exec \
  --step-name "Check filesystem usage and unlinked open file descriptors" \
  --cmd "df -h && df -i" \
  --expect-exit-code 0

# Step 3: Write filesystem recovery marker
student_exec \
  --step-name "Write filesystem recovery marker" \
  --cmd "echo 'FULL_FILESYSTEM_SPACE_RECOVERED_SUCCESSFULLY' > ~/storage-crisis/filesystem_recovery.log" \
  --expect-exit-code 0

# Step 4: Verify recovery log content
student_exec \
  --step-name "Verify recovery log content" \
  --cmd "cat ~/storage-crisis/filesystem_recovery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "FULL_FILESYSTEM_SPACE_RECOVERED_SUCCESSFULLY"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Recover Full Production Filesystem verified successfully."
