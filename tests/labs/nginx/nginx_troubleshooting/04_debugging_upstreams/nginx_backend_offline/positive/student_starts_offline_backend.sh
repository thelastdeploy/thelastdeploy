#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Start Offline Backend
# Module: nginx-troubleshooting
# Section: 04-debugging-upstreams
# Lab ID: nginx-backend-offline
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-backend-offline"

# Step 1: Student launches the backend startup script in the background
student_exec "/tmp/start_backend.sh & sleep 1" \
    --desc "Student starts the mock upstream backend server on port 8081" \
    --expect-exit 0

# Step 2: Student verifies response from /app through Nginx
student_exec "curl -s http://localhost/app" \
    --desc "Student verifies BACKEND LIVE response from upstream" \
    --expect-exit 0 \
    --expect-stdout "BACKEND LIVE"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Offline backend started and proxied successfully."
