#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create Your First Shell Script
# Module: bash-shell-scripting
# Section: 01-shell-scripts
# Lab ID: lnx-create-first-script
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-create-first-script"

# Step 1: Student creates hello.sh with shebang and echo command
student_exec "cat << 'EOF' > ~/script-test/hello.sh
#!/bin/bash
echo 'Hello, Shell!'
EOF" \
    --desc "Student writes hello.sh script with shebang" \
    --expect-exit 0

# Step 2: Student inspects the script contents
student_exec "cat ~/script-test/hello.sh" \
    --desc "Student verifies the contents of hello.sh" \
    --expect-exit 0 \
    --expect-stdout "#!/bin/bash"

# Step 3: Student adds execution permission to hello.sh
student_exec "chmod +x ~/script-test/hello.sh" \
    --desc "Student marks hello.sh as executable using chmod +x" \
    --expect-exit 0

# Step 4: Student executes the script to test output
student_exec "~/script-test/hello.sh" \
    --desc "Student runs hello.sh and asserts stdout" \
    --expect-exit 0 \
    --expect-stdout "Hello, Shell!"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Script created and executed successfully."
