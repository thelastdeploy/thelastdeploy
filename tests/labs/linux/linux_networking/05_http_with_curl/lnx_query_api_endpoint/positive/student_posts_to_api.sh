#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Submit data to an API endpoint
# Module: linux-networking
# Section: 05-http-with-curl
# Lab ID: lnx-query-api-endpoint
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-query-api-endpoint"

# Step 1: Student sends POST request to endpoint
student_exec "curl -X POST http://127.0.0.1:9090" \
    --desc "Student submits POST request to mock API" \
    --expect-exit 0 \
    --expect-stdout "created successfully"

# Step 2: Student saves POST response to api_response.txt
student_exec "mkdir -p ~/network-test && curl -s -X POST http://127.0.0.1:9090 > ~/network-test/api_response.txt" \
    --desc "Student saves API POST response" \
    --expect-exit 0

# Step 3: Student verifies recorded response
student_exec "cat ~/network-test/api_response.txt" \
    --desc "Student verifies recorded API response" \
    --expect-exit 0 \
    --expect-stdout "created successfully"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: API POST request verified successfully."
