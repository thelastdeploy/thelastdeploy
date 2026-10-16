#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Shell Environment in Bashrc
# Module: linux-environment-configuration
# Section: 02-shell-configuration
# Lab ID: lnx-configure-shell-environment
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-configure-shell-environment"

# Step 1: Student inspects the mock bashrc file
student_exec "cat ~/env-test/mock_bashrc" \
    --desc "Student inspects initial mock_bashrc file" \
    --expect-exit 0

# Step 2: Student adds export and alias definitions
student_exec "printf 'export LAB_ENV=\"tld\"\nalias syscheck=\"uptime\"\n' > ~/env-test/mock_bashrc" \
    --desc "Student configures export LAB_ENV and alias syscheck in mock_bashrc" \
    --expect-exit 0

# Step 3: Student verifies the contents of mock_bashrc
student_exec "cat ~/env-test/mock_bashrc" \
    --desc "Student verifies mock_bashrc contents" \
    --expect-exit 0 \
    --expect-stdout "export LAB_ENV=\"tld\""

# Step 4: Student tests sourcing the file in a subshell
student_exec "bash -c 'source ~/env-test/mock_bashrc && echo \"LAB_ENV=\$LAB_ENV\"'" \
    --desc "Student tests sourcing mock_bashrc" \
    --expect-exit 0 \
    --expect-stdout "LAB_ENV=tld"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Shell environment configuration verified."
