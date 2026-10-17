#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Masters Network and Storage
# Lab: lnx-master-network-and-storage
# ==============================================================================

# Step 1: Ensure mastery-admin directory exists
student_exec \
  --step-name "Ensure mastery-admin directory exists" \
  --cmd "mkdir -p ~/mastery-admin" \
  --expect-exit-code 0

# Step 2: Audit storage and network configuration
student_exec \
  --step-name "Audit storage and network configuration" \
  --cmd "df -h && ip route show" \
  --expect-exit-code 0

# Step 3: Write network and storage mastery marker
student_exec \
  --step-name "Write network and storage mastery marker" \
  --cmd "echo 'NETWORK_AND_STORAGE_ORCHESTRATION_MASTERED' > ~/mastery-admin/net_storage_mastery.log" \
  --expect-exit-code 0

# Step 4: Verify net_storage_mastery.log content
student_exec \
  --step-name "Verify net_storage_mastery.log content" \
  --cmd "cat ~/mastery-admin/net_storage_mastery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "NETWORK_AND_STORAGE_ORCHESTRATION_MASTERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Master Network and Storage verified successfully."
