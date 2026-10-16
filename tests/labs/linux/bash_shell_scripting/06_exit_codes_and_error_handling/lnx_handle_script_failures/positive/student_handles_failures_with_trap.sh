#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Handle Script Failures with Exit Codes and Traps
# Module: bash-shell-scripting
# Section: 06-exit-codes-and-error-handling
# Lab ID: lnx-handle-script-failures
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-handle-script-failures"

# Step 1: Student writes resilient.sh with directory validation and trap cleanup
student_exec "cat << 'EOF' > ~/script-test/resilient.sh
#!/bin/bash
set -euo pipefail

TARGET_DIR=\"\${1:-}\"

if [ -z \"\$TARGET_DIR\" ] || [ ! -d \"\$TARGET_DIR\" ]; then
    echo \"Error: Directory '\$TARGET_DIR' does not exist.\" >&2
    exit 1
fi

TEMP_FILE=\"\$TARGET_DIR/temp.txt\"
touch \"\$TEMP_FILE\"

cleanup() {
    rm -f \"\$TEMP_FILE\"
}

trap cleanup EXIT

echo \"Processing \$TARGET_DIR...\"
exit 0
EOF" \
    --desc "Student writes resilient.sh with exit codes and trap handler" \
    --expect-exit 0

# Step 2: Student inspects the script contents
student_exec "cat ~/script-test/resilient.sh" \
    --desc "Student inspects resilient.sh contents" \
    --expect-exit 0 \
    --expect-stdout "trap cleanup EXIT"

# Step 3: Student adds execution permission
student_exec "chmod +x ~/script-test/resilient.sh" \
    --desc "Student marks resilient.sh executable" \
    --expect-exit 0

# Step 4: Student tests error handling with a missing directory
student_exec "~/script-test/resilient.sh ~/script-test/non_existent_directory || echo 'Failed as expected with non-zero exit'" \
    --desc "Student tests non-existent directory exit code" \
    --expect-exit 0 \
    --expect-stdout "Failed as expected with non-zero exit"

# Step 5: Student tests execution with a valid target directory
student_exec "~/script-test/resilient.sh ~/script-test/target_dir" \
    --desc "Student runs resilient.sh with valid directory" \
    --expect-exit 0 \
    --expect-stdout "Processing"

# Step 6: Student confirms that temp.txt was cleaned up automatically by trap
student_exec "test ! -f ~/script-test/target_dir/temp.txt && echo 'Cleanup verified'" \
    --desc "Student confirms temp file was deleted on exit" \
    --expect-exit 0 \
    --expect-stdout "Cleanup verified"

# Step 7: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Exit codes and signal trap handlers verified successfully."
