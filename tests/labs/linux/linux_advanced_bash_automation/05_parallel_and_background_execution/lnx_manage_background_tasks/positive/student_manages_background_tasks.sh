#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Manages Background Tasks
# Lab: lnx-manage-background-tasks
# ==============================================================================

# Step 1: Ensure bg-test directory exists
student_exec \
  --step-name "Ensure bg-test directory exists" \
  --cmd "mkdir -p ~/bg-test" \
  --expect-exit-code 0

# Step 2: Create bg_runner.sh script
student_exec \
  --step-name "Create bg_runner.sh script" \
  --cmd "cat << 'EOF' > ~/bg-test/bg_runner.sh
#!/bin/bash
set -euo pipefail

echo 'task1' > ~/bg-test/t1.txt &
echo 'task2' > ~/bg-test/t2.txt &
echo 'task3' > ~/bg-test/t3.txt &

wait

echo 'ALL_JOBS_DONE' > ~/bg-test/jobs_complete.txt
EOF
chmod +x ~/bg-test/bg_runner.sh" \
  --expect-exit-code 0

# Step 3: Execute bg_runner.sh
student_exec \
  --step-name "Execute bg_runner.sh" \
  --cmd "~/bg-test/bg_runner.sh" \
  --expect-exit-code 0

# Step 4: Verify completion marker
student_exec \
  --step-name "Verify jobs_complete.txt content" \
  --cmd "cat ~/bg-test/jobs_complete.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ALL_JOBS_DONE"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Background task management verified."
