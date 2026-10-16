#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Validate System State and File Properties
# Module: bash-shell-scripting
# Section: 03-conditions
# Lab ID: lnx-validate-system-state
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-validate-system-state"

# Step 1: Student writes check_file.sh using -f and -s file tests
student_exec "cat << 'EOF' > ~/script-test/check_file.sh
#!/bin/bash
set -euo pipefail

FILE_PATH=\"\$1\"

if [ -f \"\$FILE_PATH\" ]; then
    if [ -s \"\$FILE_PATH\" ]; then
        echo \"FILE_EXISTS NON_EMPTY\"
    else
        echo \"FILE_EXISTS EMPTY\"
    fi
else
    echo \"FILE_MISSING\"
fi
EOF" \
    --desc "Student writes check_file.sh with file property tests" \
    --expect-exit 0

# Step 2: Student inspects the script contents
student_exec "cat ~/script-test/check_file.sh" \
    --desc "Student inspects check_file.sh contents" \
    --expect-exit 0 \
    --expect-stdout "NON_EMPTY"

# Step 3: Student adds execution permission
student_exec "chmod +x ~/script-test/check_file.sh" \
    --desc "Student marks check_file.sh executable" \
    --expect-exit 0

# Step 4: Student tests with non-existent file
student_exec "~/script-test/check_file.sh ~/script-test/missing_file.txt" \
    --desc "Student tests missing file condition" \
    --expect-exit 0 \
    --expect-stdout "FILE_MISSING"

# Step 5: Student tests with empty file
student_exec "~/script-test/check_file.sh ~/script-test/empty_sample.txt" \
    --desc "Student tests empty existing file condition" \
    --expect-exit 0 \
    --expect-stdout "FILE_EXISTS"

# Step 6: Student tests with active non-empty file
student_exec "~/script-test/check_file.sh ~/script-test/active_sample.txt" \
    --desc "Student tests active non-empty file condition" \
    --expect-exit 0 \
    --expect-stdout "FILE_EXISTS NON_EMPTY"

# Step 7: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: System state and file validation logic verified."
