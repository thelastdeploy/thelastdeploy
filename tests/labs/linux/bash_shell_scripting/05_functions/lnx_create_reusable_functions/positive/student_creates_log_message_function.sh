#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create Reusable Functions
# Module: bash-shell-scripting
# Section: 05-functions
# Lab ID: lnx-create-reusable-functions
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-create-reusable-functions"

# Step 1: Student writes log_helper.sh containing log_message function
student_exec "cat << 'EOF' > ~/script-test/log_helper.sh
#!/bin/bash

log_message() {
    local LEVEL=\"\$1\"
    local MESSAGE=\"\$2\"
    echo \"[\$LEVEL] \$MESSAGE\"
}
EOF" \
    --desc "Student writes log_helper.sh with log_message function" \
    --expect-exit 0

# Step 2: Student inspects the script contents
student_exec "cat ~/script-test/log_helper.sh" \
    --desc "Student inspects log_helper.sh contents" \
    --expect-exit 0 \
    --expect-stdout "log_message"

# Step 3: Student adds execution permission
student_exec "chmod +x ~/script-test/log_helper.sh" \
    --desc "Student marks log_helper.sh executable" \
    --expect-exit 0

# Step 4: Student tests function behavior by sourcing and invoking log_message
student_exec "bash -c \"source ~/script-test/log_helper.sh && log_message 'INFO' 'Database connected'\"" \
    --desc "Student tests log_message function formatting" \
    --expect-exit 0 \
    --expect-stdout "[INFO] Database connected"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Function 'log_message' verified."
