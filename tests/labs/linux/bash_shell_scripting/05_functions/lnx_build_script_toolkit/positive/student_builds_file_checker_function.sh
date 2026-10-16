#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Build a Script Helper Toolkit
# Module: bash-shell-scripting
# Section: 05-functions
# Lab ID: lnx-build-script-toolkit
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-build-script-toolkit"

# Step 1: Student creates toolkit.sh containing is_file_present function
student_exec "cat << 'EOF' > ~/script-test/toolkit.sh
#!/bin/bash

is_file_present() {
    local FILE=\"\$1\"
    if [ -f \"\$FILE\" ]; then
        return 0
    else
        return 1
    fi
}
EOF" \
    --desc "Student writes toolkit.sh with is_file_present function" \
    --expect-exit 0

# Step 2: Student inspects the script contents
student_exec "cat ~/script-test/toolkit.sh" \
    --desc "Student inspects toolkit.sh contents" \
    --expect-exit 0 \
    --expect-stdout "is_file_present"

# Step 3: Student adds execution permission
student_exec "chmod +x ~/script-test/toolkit.sh" \
    --desc "Student marks toolkit.sh executable" \
    --expect-exit 0

# Step 4: Student tests function behavior with an existing file
student_exec "touch ~/script-test/sample.tmp && bash -c \"source ~/script-test/toolkit.sh && is_file_present ~/script-test/sample.tmp && echo 'Present'\"" \
    --desc "Student tests is_file_present on existing file" \
    --expect-exit 0 \
    --expect-stdout "Present"

# Step 5: Student tests function behavior with a missing file
student_exec "bash -c \"source ~/script-test/toolkit.sh && if ! is_file_present ~/script-test/missing.tmp; then echo 'Absent'; fi\"" \
    --desc "Student tests is_file_present on missing file" \
    --expect-exit 0 \
    --expect-stdout "Absent"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Function 'is_file_present' in toolkit.sh validated."
