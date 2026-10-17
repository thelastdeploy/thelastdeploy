#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Protects Automation with Lock Files and Atomic Swaps
# Lab: lnx-protect-automation-from-failure
# ==============================================================================

# Step 1: Ensure atomic-test directory exists and seed initial target.txt
student_exec \
  --step-name "Ensure directory exists and seed target.txt" \
  --cmd "mkdir -p ~/atomic-test && echo 'initial_data' > ~/atomic-test/target.txt" \
  --expect-exit-code 0

# Step 2: Create safe_update.sh script
student_exec \
  --step-name "Create safe_update.sh script" \
  --cmd "cat << 'EOF' > ~/atomic-test/safe_update.sh
#!/bin/bash
set -euo pipefail

LOCKFILE=\"\$HOME/atomic-test/script.lock\"
TARGET=\"\$HOME/atomic-test/target.txt\"

exec 200>\"\$LOCKFILE\"
flock -n 200 || { echo \"Script is already running\"; exit 1; }

TMPFILE=\$(mktemp \"\$HOME/atomic-test/tmp.XXXXXX\")
echo \"updated_data_\$(date +%s)\" > \"\$TMPFILE\"
mv \"\$TMPFILE\" \"\$TARGET\"
EOF
chmod +x ~/atomic-test/safe_update.sh" \
  --expect-exit-code 0

# Step 3: Execute safe_update.sh
student_exec \
  --step-name "Execute safe_update.sh" \
  --cmd "~/atomic-test/safe_update.sh" \
  --expect-exit-code 0

# Step 4: Verify target.txt content
student_exec \
  --step-name "Verify target.txt content" \
  --cmd "cat ~/atomic-test/target.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "updated_data_"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Atomic file replacement and lock protection verified."
