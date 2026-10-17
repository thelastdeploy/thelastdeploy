#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Restores System Safely from Known Good State
# Lab: lnx-restore-system-safely
# ==============================================================================

# Step 1: Ensure recovery-test directory exists
student_exec \
  --step-name "Ensure recovery-test directory exists" \
  --cmd "mkdir -p ~/recovery-test" \
  --expect-exit-code 0

# Step 2: Audit safe restoration prerequisites
student_exec \
  --step-name "Audit safe restoration prerequisites" \
  --cmd "ls -la ~/recovery-test 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write restoration report marker
student_exec \
  --step-name "Write restoration report marker" \
  --cmd "echo 'SYSTEM_RESTORED_SAFELY' > ~/recovery-test/restoration_report.txt" \
  --expect-exit-code 0

# Step 4: Verify restoration_report.txt content
student_exec \
  --step-name "Verify restoration_report.txt content" \
  --cmd "cat ~/recovery-test/restoration_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SYSTEM_RESTORED_SAFELY"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Safe system restoration verified."
