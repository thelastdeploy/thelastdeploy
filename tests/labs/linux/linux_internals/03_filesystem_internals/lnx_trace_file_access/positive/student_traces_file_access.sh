#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces File Access and Open File Table
# Lab: lnx-trace-file-access
# ==============================================================================

# Step 1: Ensure vfs-test directory exists
student_exec \
  --step-name "Ensure vfs-test directory exists" \
  --cmd "mkdir -p ~/vfs-test" \
  --expect-exit-code 0

# Step 2: Inspect file locks
student_exec \
  --step-name "Inspect /proc/locks" \
  --cmd "cat /proc/locks | head -n 10" \
  --expect-exit-code 0

# Step 3: Write file locks traced marker
student_exec \
  --step-name "Write file locks marker" \
  --cmd "echo 'FILE_LOCKS_TRACED' > ~/vfs-test/file_locks.txt" \
  --expect-exit-code 0

# Step 4: Verify content of file_locks.txt
student_exec \
  --step-name "Verify file_locks.txt content" \
  --cmd "cat ~/vfs-test/file_locks.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "FILE_LOCKS_TRACED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: File access and open file table tracing verified."
