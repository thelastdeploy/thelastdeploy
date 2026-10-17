#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Secures Mounted Storage Permissions
# Lab: lnx-secure-mounted-storage
# ==============================================================================

# Step 1: Ensure target directory exists with initial restrictive permissions
student_exec \
  --step-name "Ensure mounted_dir exists" \
  --cmd "mkdir -p ~/storage-test/mounted_dir" \
  --expect-exit-code 0

# Step 2: Set permissions to 755 on mounted_dir
student_exec \
  --step-name "Set directory permissions to 755" \
  --cmd "chmod 755 ~/storage-test/mounted_dir" \
  --expect-exit-code 0

# Step 3: Record owner and group in sec_audit.txt
student_exec \
  --step-name "Audit and record directory ownership" \
  --cmd "stat -c '%U:%G' ~/storage-test/mounted_dir > ~/storage-test/sec_audit.txt" \
  --expect-exit-code 0

# Step 4: Verify permissions and audit output
student_exec \
  --step-name "Verify permissions and audit file content" \
  --cmd "stat -c '%a' ~/storage-test/mounted_dir && cat ~/storage-test/sec_audit.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "755"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Mounted storage permissions secured and audited correctly."
