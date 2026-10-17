#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Reduces Storage Capacity Safely
# Lab: lnx-reduce-storage-safely
# ==============================================================================

# Step 1: Ensure resize-test directory exists
student_exec \
  --step-name "Ensure resize-test directory exists" \
  --cmd "mkdir -p ~/resize-test" \
  --expect-exit-code 0

# Step 2: Write safe reduction sequence to safe_reduce_steps.txt
student_exec \
  --step-name "Write safe reduction steps" \
  --cmd "cat << 'EOF' > ~/resize-test/safe_reduce_steps.txt
1. umount
2. e2fsck -f
3. resize2fs
4. lvreduce
5. mount
EOF" \
  --expect-exit-code 0

# Step 3: Verify content of safe_reduce_steps.txt
student_exec \
  --step-name "Verify safe_reduce_steps.txt content" \
  --cmd "cat ~/resize-test/safe_reduce_steps.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "1. umount"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Safe storage reduction sequence verified."
