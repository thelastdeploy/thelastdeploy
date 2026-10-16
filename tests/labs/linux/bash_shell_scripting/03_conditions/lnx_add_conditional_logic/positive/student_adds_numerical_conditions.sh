#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Add Conditional Logic
# Module: bash-shell-scripting
# Section: 03-conditions
# Lab ID: lnx-add-conditional-logic
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-add-conditional-logic"

# Step 1: Student writes check_num.sh with if/elif/else structure
student_exec "cat << 'EOF' > ~/script-test/check_num.sh
#!/bin/bash
set -euo pipefail

NUM=\"\$1\"

if [ \"\$NUM\" -gt 0 ]; then
    echo \"POSITIVE\"
elif [ \"\$NUM\" -lt 0 ]; then
    echo \"NEGATIVE\"
else
    echo \"ZERO\"
fi
EOF" \
    --desc "Student writes check_num.sh using numerical comparisons" \
    --expect-exit 0

# Step 2: Student inspects the script contents
student_exec "cat ~/script-test/check_num.sh" \
    --desc "Student verifies check_num.sh contents" \
    --expect-exit 0 \
    --expect-stdout "POSITIVE"

# Step 3: Student adds execution permission
student_exec "chmod +x ~/script-test/check_num.sh" \
    --desc "Student marks check_num.sh executable" \
    --expect-exit 0

# Step 4: Student tests positive number
student_exec "~/script-test/check_num.sh 10" \
    --desc "Student tests positive argument" \
    --expect-exit 0 \
    --expect-stdout "POSITIVE"

# Step 5: Student tests negative number
student_exec "~/script-test/check_num.sh -5" \
    --desc "Student tests negative argument" \
    --expect-exit 0 \
    --expect-stdout "NEGATIVE"

# Step 6: Student tests zero
student_exec "~/script-test/check_num.sh 0" \
    --desc "Student tests zero argument" \
    --expect-exit 0 \
    --expect-stdout "ZERO"

# Step 7: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Numerical conditional logic verified."
