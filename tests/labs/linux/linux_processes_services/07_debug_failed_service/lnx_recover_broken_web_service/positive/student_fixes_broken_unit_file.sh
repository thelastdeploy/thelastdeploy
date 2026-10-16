#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix a failing user service
# Module: linux-processes-services
# Section: 07-debug-failed-service
# Lab ID: lnx-recover-broken-web-service
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-recover-broken-web-service"

# Step 1: Student attempts to start the service and checks status
student_exec "systemctl --user start thelastdeploy-broken.service || true" \
    --desc "Student triggers start on failing unit" \
    --expect-exit 0

student_exec "systemctl --user status thelastdeploy-broken.service || true" \
    --desc "Student inspects failure logs and status" \
    --expect-exit 0

# Step 2: Student inspects the unit configuration
student_exec "cat ~/.config/systemd/user/thelastdeploy-broken.service" \
    --desc "Student reads unit file to locate configuration error" \
    --expect-exit 0 \
    --expect-stdout "ExecStart"

# Step 3: Student fixes the invalid executable path in the unit file
student_exec "sed -i 's|/bin/sleepy 3600|/bin/sleep 3600|' ~/.config/systemd/user/thelastdeploy-broken.service" \
    --desc "Student corrects ExecStart path in unit file" \
    --expect-exit 0

# Step 4: Student reloads the user systemd daemon
student_exec "systemctl --user daemon-reload" \
    --desc "Student reloads user systemd daemon" \
    --expect-exit 0

# Step 5: Student starts the repaired service
student_exec "systemctl --user start thelastdeploy-broken.service" \
    --desc "Student starts the repaired service" \
    --expect-exit 0

# Step 6: Student verifies the service is now active
student_exec "systemctl --user is-active thelastdeploy-broken.service" \
    --desc "Student verifies active service status" \
    --expect-exit 0 \
    --expect-stdout "active"

# Step 7: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Failing service successfully debugged and running."
