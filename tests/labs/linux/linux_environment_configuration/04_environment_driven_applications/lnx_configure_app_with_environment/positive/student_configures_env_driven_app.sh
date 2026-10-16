#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Environment-Driven Applications
# Module: linux-environment-configuration
# Section: 04-environment-driven-applications
# Lab ID: lnx-configure-app-with-environment
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-configure-app-with-environment"

# Step 1: Student inspects the seeded app.env file
student_exec "cat ~/env-test/app.env" \
    --desc "Student inspects app.env key-value definitions" \
    --expect-exit 0 \
    --expect-stdout "PORT=5000"

# Step 2: Student creates launcher script run_app.sh sourcing app.env
student_exec "printf '#!/bin/bash\nset -a\nsource \"\$HOME/env-test/app.env\"\nset +a\nprintf \"PORT=%%s\\\\nLOG_LEVEL=%%s\\\\n\" \"\$PORT\" \"\$LOG_LEVEL\" > \"\$HOME/env-test/app_runtime.log\"\n' > ~/env-test/run_app.sh" \
    --desc "Student writes run_app.sh to load app.env and record active variables" \
    --expect-exit 0

# Step 3: Student makes launcher script executable
student_exec "chmod +x ~/env-test/run_app.sh" \
    --desc "Student grants execute permissions on run_app.sh" \
    --expect-exit 0

# Step 4: Student reviews run_app.sh contents
student_exec "cat ~/env-test/run_app.sh" \
    --desc "Student verifies launcher script structure" \
    --expect-exit 0 \
    --expect-stdout "app_runtime.log"

# Step 5: Student executes run_app.sh
student_exec "~/env-test/run_app.sh" \
    --desc "Student runs the launcher script to generate runtime log" \
    --expect-exit 0

# Step 6: Student confirms generated runtime log contents
student_exec "cat ~/env-test/app_runtime.log" \
    --desc "Student inspects app_runtime.log" \
    --expect-exit 0 \
    --expect-stdout "LOG_LEVEL=debug"

# Step 7: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Environment-driven application loader script verified."
