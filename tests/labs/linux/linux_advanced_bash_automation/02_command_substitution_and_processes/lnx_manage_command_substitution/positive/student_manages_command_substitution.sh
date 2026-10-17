#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Manages Advanced Process Substitution
# Lab: lnx-manage-command-substitution
# ==============================================================================

# Step 1: Ensure proc-sub-test directory exists
student_exec \
  --step-name "Ensure proc-sub-test directory exists" \
  --cmd "mkdir -p ~/proc-sub-test" \
  --expect-exit-code 0

# Step 2: Seed comparison lists
student_exec \
  --step-name "Seed comparison lists" \
  --cmd "printf 'nginx\nredis\nmysql\n' > ~/proc-sub-test/old_list.txt && printf 'nginx\nredis\npostgresql\n' > ~/proc-sub-test/new_list.txt" \
  --expect-exit-code 0

# Step 3: Run process substitution diff comparison
student_exec \
  --step-name "Run process substitution diff" \
  --cmd "comm -13 <(sort ~/proc-sub-test/old_list.txt) <(sort ~/proc-sub-test/new_list.txt) > ~/proc-sub-test/diff_report.txt" \
  --expect-exit-code 0

# Step 4: Verify diff report content
student_exec \
  --step-name "Verify diff report content" \
  --cmd "cat ~/proc-sub-test/diff_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "postgresql"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Process substitution diff report verified."
