#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Broken Boot Configuration
# Lab: lnx-recover-broken-boot-configuration
# ==============================================================================

# Step 1: Ensure boot-fail-test directory exists with sample fstab.broken if missing
student_exec \
  --step-name "Ensure sample fstab.broken exists" \
  --cmd "mkdir -p ~/boot-fail-test && [ -f ~/boot-fail-test/fstab.broken ] || echo 'UUID=ffff-ffff /data ext4 defaults 0 2' > ~/boot-fail-test/fstab.broken" \
  --expect-exit-code 0

# Step 2: Fix configuration by adding nofail option to fstab.fixed
student_exec \
  --step-name "Generate repaired fstab.fixed" \
  --cmd "sed 's/defaults/defaults,nofail/' ~/boot-fail-test/fstab.broken > ~/boot-fail-test/fstab.fixed" \
  --expect-exit-code 0

# Step 3: Verify content of fstab.fixed
student_exec \
  --step-name "Verify fstab.fixed content" \
  --cmd "cat ~/boot-fail-test/fstab.fixed" \
  --expect-exit-code 0 \
  --expect-stdout-contains "nofail"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Broken boot configuration recovery verified."
