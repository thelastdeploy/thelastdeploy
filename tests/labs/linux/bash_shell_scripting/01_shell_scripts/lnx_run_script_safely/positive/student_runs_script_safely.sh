#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Run Scripts Safely with Strict Options
# Module: bash-shell-scripting
# Section: 01-shell-scripts
# Lab ID: lnx-run-script-safely
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-run-script-safely"

# Step 1: Student creates safe.sh with shebang, strict flags, and echo statement
student_exec "cat << 'EOF' > ~/script-test/safe.sh
#!/bin/bash
set -euo pipefail

echo 'Safe Execution'
EOF" \
    --desc "Student writes safe.sh with strict execution options" \
    --expect-exit 0

# Step 2: Student inspects the script contents
student_exec "cat ~/script-test/safe.sh" \
    --desc "Student inspects safe.sh contents" \
    --expect-exit 0 \
    --expect-stdout "set -euo pipefail"

# Step 3: Student adds execution permission to safe.sh
student_exec "chmod +x ~/script-test/safe.sh" \
    --desc "Student makes safe.sh executable with chmod +x" \
    --expect-exit 0

# Step 4: Student executes safe.sh to test output
student_exec "~/script-test/safe.sh" \
    --desc "Student runs safe.sh and asserts stdout" \
    --expect-exit 0 \
    --expect-stdout "Safe Execution"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Script configured with strict execution mode."
