#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Unbootable Linux Server Capstone
# Lab: lnx-recover-unbootable-system
# ==============================================================================

# Step 1: Ensure boot-capstone directory exists
student_exec \
  --step-name "Ensure boot-capstone directory exists" \
  --cmd "mkdir -p ~/boot-capstone" \
  --expect-exit-code 0

# Step 2: Create repair_boot.sh script
student_exec \
  --step-name "Create repair_boot.sh script" \
  --cmd "cat << 'EOF' > ~/boot-capstone/repair_boot.sh
#!/bin/bash
echo 'Repairing boot configuration...'
EOF
chmod +x ~/boot-capstone/repair_boot.sh" \
  --expect-exit-code 0

# Step 3: Write recovery summary line to recovery.log
student_exec \
  --step-name "Write recovery summary" \
  --cmd "echo 'UNBOOTABLE_SYSTEM_RECOVERED' > ~/boot-capstone/recovery.log" \
  --expect-exit-code 0

# Step 4: Verify content of recovery.log
student_exec \
  --step-name "Verify recovery.log content" \
  --cmd "cat ~/boot-capstone/recovery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "UNBOOTABLE_SYSTEM_RECOVERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Unbootable system recovery capstone verified."
