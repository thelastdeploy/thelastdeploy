#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Userspace Initialization Sequence
# Lab: lnx-trace-userspace-initialization
# ==============================================================================

# Step 1: Ensure sys-init-test directory exists
student_exec \
  --step-name "Ensure sys-init-test directory exists" \
  --cmd "mkdir -p ~/sys-init-test" \
  --expect-exit-code 0

# Step 2: Write summary line to boot_time.txt
student_exec \
  --step-name "Write boot time summary" \
  --cmd "echo 'BOOT_TIME_ANALYZED' > ~/sys-init-test/boot_time.txt" \
  --expect-exit-code 0

# Step 3: Verify content of boot_time.txt
student_exec \
  --step-name "Verify boot_time.txt content" \
  --cmd "cat ~/sys-init-test/boot_time.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "BOOT_TIME_ANALYZED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Userspace initialization sequence trace verified."
