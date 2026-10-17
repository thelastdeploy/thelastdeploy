#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Bootloader Configuration
# Lab: lnx-inspect-bootloader-configuration
# ==============================================================================

# Step 1: Ensure grub-test directory exists
student_exec \
  --step-name "Ensure grub-test directory exists" \
  --cmd "mkdir -p ~/grub-test" \
  --expect-exit-code 0

# Step 2: Write summary line to grub_summary.txt
student_exec \
  --step-name "Write grub configuration summary" \
  --cmd "echo 'GRUB_CONFIG_INSPECTED' > ~/grub-test/grub_summary.txt" \
  --expect-exit-code 0

# Step 3: Verify content of grub_summary.txt
student_exec \
  --step-name "Verify grub_summary.txt content" \
  --cmd "cat ~/grub-test/grub_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "GRUB_CONFIG_INSPECTED"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Bootloader configuration inspection verified."
