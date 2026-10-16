#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Enable a user-level service
# Module: linux-processes-services
# Section: 05-systemd-and-services
# Lab ID: lnx-enable-service
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-enable-service"

# Step 1: Student inspects the user-level service status
student_exec "systemctl --user status thelastdeploy-user.service || true" \
    --desc "Student inspects status of thelastdeploy-user.service" \
    --expect-exit 0

# Step 2: Student enables the user service to start on login
student_exec "systemctl --user enable thelastdeploy-user.service" \
    --desc "Student enables thelastdeploy-user.service" \
    --expect-exit 0

# Step 3: Student verifies the service is enabled
student_exec "systemctl --user is-enabled thelastdeploy-user.service" \
    --desc "Student checks is-enabled status" \
    --expect-exit 0 \
    --expect-stdout "enabled"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: User-level service enabled successfully."
