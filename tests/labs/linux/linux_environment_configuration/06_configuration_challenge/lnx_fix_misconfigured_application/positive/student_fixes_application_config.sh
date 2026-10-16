#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix Misconfigured Application and Environment
# Module: linux-environment-configuration
# Section: 06-configuration-challenge
# Lab ID: lnx-fix-misconfigured-application
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-fix-misconfigured-application"

# Step 1: Student inspects the broken application configuration
student_exec "cat ~/config-challenge/app.conf" \
    --desc "Student inspects invalid configuration parameters in app.conf" \
    --expect-exit 0 \
    --expect-stdout "DB_HOST=localhost_invalid"

# Step 2: Student inspects the environment template
student_exec "cat ~/config-challenge/.env.template" \
    --desc "Student inspects .env.template" \
    --expect-exit 0 \
    --expect-stdout "APP_KEY=secret_key_123"

# Step 3: Student corrects database host and port settings in app.conf
student_exec "printf 'DB_HOST=db.internal\nPORT=8080\n' > ~/config-challenge/app.conf" \
    --desc "Student updates app.conf with required DB_HOST and PORT" \
    --expect-exit 0

# Step 4: Student verifies corrected app.conf
student_exec "cat ~/config-challenge/app.conf" \
    --desc "Student verifies updated app.conf" \
    --expect-exit 0 \
    --expect-stdout "DB_HOST=db.internal"

# Step 5: Student creates .env from template
student_exec "cp ~/config-challenge/.env.template ~/config-challenge/.env" \
    --desc "Student generates active .env file from template" \
    --expect-exit 0

# Step 6: Student verifies active .env
student_exec "cat ~/config-challenge/.env" \
    --desc "Student verifies .env file contents" \
    --expect-exit 0 \
    --expect-stdout "APP_KEY=secret_key_123"

# Step 7: Student writes verification status report
student_exec "echo 'APP_CONFIG_STATUS: VERIFIED' > ~/config-challenge/fix_report.txt" \
    --desc "Student creates fix_report.txt verification summary" \
    --expect-exit 0

# Step 8: Student verifies fix_report.txt
student_exec "cat ~/config-challenge/fix_report.txt" \
    --desc "Student confirms fix_report.txt contents" \
    --expect-exit 0 \
    --expect-stdout "APP_CONFIG_STATUS: VERIFIED"

# Step 9: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Environment & configuration capstone challenge verified."
