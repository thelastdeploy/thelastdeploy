#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Work with Script Variables and Arguments
# Module: bash-shell-scripting
# Section: 02-variables-and-input
# Lab ID: lnx-work-with-script-variables
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-work-with-script-variables"

# Step 1: Student writes vars.sh using positional parameters $1 and $2
student_exec "cat << 'EOF' > ~/script-test/vars.sh
#!/bin/bash
set -euo pipefail

echo \"User \$1 assigned role \$2\"
EOF" \
    --desc "Student writes vars.sh using positional parameters" \
    --expect-exit 0

# Step 2: Student inspects the script contents
student_exec "cat ~/script-test/vars.sh" \
    --desc "Student inspects vars.sh contents" \
    --expect-exit 0 \
    --expect-stdout "User \$1 assigned role \$2"

# Step 3: Student adds execution permission
student_exec "chmod +x ~/script-test/vars.sh" \
    --desc "Student marks vars.sh executable" \
    --expect-exit 0

# Step 4: Student tests running vars.sh with sample arguments
student_exec "~/script-test/vars.sh Alice Developer" \
    --desc "Student tests vars.sh with positional arguments" \
    --expect-exit 0 \
    --expect-stdout "User Alice assigned role Developer"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Script processes positional variables correctly."
