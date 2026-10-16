#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Build an Interactive Shell Script
# Module: bash-shell-scripting
# Section: 02-variables-and-input
# Lab ID: lnx-build-interactive-script
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-build-interactive-script"

# Step 1: Student writes interactive.sh using read -p
student_exec "cat << 'EOF' > ~/script-test/interactive.sh
#!/bin/bash
set -euo pipefail

read -p 'Enter service name: ' SERVICE_NAME
read -p 'Enter environment: ' ENV_NAME

echo \"Deploying \$SERVICE_NAME to \$ENV_NAME\"
EOF" \
    --desc "Student writes interactive.sh using read -p prompts" \
    --expect-exit 0

# Step 2: Student inspects the script contents
student_exec "cat ~/script-test/interactive.sh" \
    --desc "Student inspects interactive.sh contents" \
    --expect-exit 0 \
    --expect-stdout "read -p"

# Step 3: Student adds execution permission
student_exec "chmod +x ~/script-test/interactive.sh" \
    --desc "Student marks interactive.sh executable" \
    --expect-exit 0

# Step 4: Student tests running interactive.sh with piped inputs
student_exec "printf 'api-server\nproduction\n' | ~/script-test/interactive.sh" \
    --desc "Student tests interactive execution with test inputs" \
    --expect-exit 0 \
    --expect-stdout "Deploying api-server to production"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Interactive script validated successfully."
