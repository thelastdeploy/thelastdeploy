#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Export Environment Variables for Child Processes
# Module: linux-environment-configuration
# Section: 01-environment-variables
# Lab ID: lnx-manage-environment-variables
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-manage-environment-variables"

# Step 1: Student creates export script with required variables
student_exec "printf '#!/bin/bash\nexport APP_PORT=8080\nexport APP_ENV=staging\n' > ~/env-test/export_cmd.sh" \
    --desc "Student writes script exporting APP_PORT and APP_ENV" \
    --expect-exit 0

# Step 2: Student marks script as executable
student_exec "chmod +x ~/env-test/export_cmd.sh" \
    --desc "Student grants execute permissions on export script" \
    --expect-exit 0

# Step 3: Student inspects the script contents
student_exec "cat ~/env-test/export_cmd.sh" \
    --desc "Student reviews export script contents" \
    --expect-exit 0 \
    --expect-stdout "export APP_PORT=8080"

# Step 4: Student runs the script to verify execution
student_exec "~/env-test/export_cmd.sh" \
    --desc "Student executes the export script" \
    --expect-exit 0

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Environment exports script verified."
