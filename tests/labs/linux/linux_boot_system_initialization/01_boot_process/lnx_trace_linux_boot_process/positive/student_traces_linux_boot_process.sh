#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Linux Boot Process Stages
# Lab: lnx-trace-linux-boot-process
# ==============================================================================

# Step 1: Ensure boot-test directory exists
student_exec \
  --step-name "Ensure boot-test directory exists" \
  --cmd "mkdir -p ~/boot-test" \
  --expect-exit-code 0

# Step 2: Write ordered boot stages to boot_stages.txt
student_exec \
  --step-name "Write boot stages to boot_stages.txt" \
  --cmd "cat << 'EOF' > ~/boot-test/boot_stages.txt
1. FIRMWARE
2. BOOTLOADER
3. KERNEL
4. INITRAMFS
5. SYSTEMD
EOF" \
  --expect-exit-code 0

# Step 3: Verify content of boot_stages.txt
student_exec \
  --step-name "Verify boot_stages.txt content" \
  --cmd "cat ~/boot-test/boot_stages.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "1. FIRMWARE"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Linux boot process stages verified."
