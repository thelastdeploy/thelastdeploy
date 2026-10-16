#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Start a user-level service
# Module: linux-processes-services
# Section: 05-systemd-and-services
# Lab ID: lnx-start-service
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-start-service"

# Step 1: Student checks initial status of the user-level service
student_exec "systemctl --user status thelastdeploy-user.service || true" \
    --desc "Student inspects status of thelastdeploy-user.service" \
    --expect-exit 0

# Step 2: Student starts the user-level service
student_exec "systemctl --user start thelastdeploy-user.service" \
    --desc "Student starts thelastdeploy-user.service" \
    --expect-exit 0

# Step 3: Student verifies the service is active
student_exec "systemctl --user is-active thelastdeploy-user.service" \
    --desc "Student checks is-active status" \
    --expect-exit 0 \
    --expect-stdout "active"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: User-level service started successfully."
