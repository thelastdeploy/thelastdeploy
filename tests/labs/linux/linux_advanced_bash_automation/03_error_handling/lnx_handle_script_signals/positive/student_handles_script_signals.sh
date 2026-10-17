#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Handles Script Traps and Signals
# Lab: lnx-handle-script-signals
# ==============================================================================

# Step 1: Ensure trap-test directory exists
student_exec \
  --step-name "Ensure trap-test directory exists" \
  --cmd "mkdir -p ~/trap-test" \
  --expect-exit-code 0

# Step 2: Create trap_demo.sh script
student_exec \
  --step-name "Create trap_demo.sh script" \
  --cmd "cat << 'EOF' > ~/trap-test/trap_demo.sh
#!/bin/bash
set -euo pipefail

LOCK=\"\$HOME/trap-test/work.lock\"
LOG=\"\$HOME/trap-test/cleanup_log.txt\"

cleanup() {
    rm -f \"\$LOCK\"
    echo \"Cleaned up lock file\" >> \"\$LOG\"
}

trap cleanup EXIT SIGINT SIGTERM

touch \"\$LOCK\"
echo \"Working...\"
EOF
chmod +x ~/trap-test/trap_demo.sh" \
  --expect-exit-code 0

# Step 3: Execute trap_demo.sh
student_exec \
  --step-name "Execute trap_demo.sh to trigger trap" \
  --cmd "~/trap-test/trap_demo.sh" \
  --expect-exit-code 0

# Step 4: Verify cleanup_log.txt content
student_exec \
  --step-name "Verify cleanup_log.txt content" \
  --cmd "cat ~/trap-test/cleanup_log.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Cleaned up lock file"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Script signal trap handling verified."
