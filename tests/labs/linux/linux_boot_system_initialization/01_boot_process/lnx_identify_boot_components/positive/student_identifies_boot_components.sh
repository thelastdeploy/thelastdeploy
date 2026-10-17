#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Identifies Core Boot Components
# Lab: lnx-identify-boot-components
# ==============================================================================

# Step 1: Ensure boot-test directory exists
student_exec \
  --step-name "Ensure boot-test directory exists" \
  --cmd "mkdir -p ~/boot-test" \
  --expect-exit-code 0

# Step 2: Write inspection summary line to boot_files.txt
student_exec \
  --step-name "Write boot components summary" \
  --cmd "echo 'BOOT_COMPONENTS_INSPECTED' > ~/boot-test/boot_files.txt" \
  --expect-exit-code 0

# Step 3: Verify content of boot_files.txt
student_exec \
  --step-name "Verify boot_files.txt content" \
  --cmd "cat ~/boot-test/boot_files.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "BOOT_COMPONENTS_INSPECTED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Core boot components identification verified."
