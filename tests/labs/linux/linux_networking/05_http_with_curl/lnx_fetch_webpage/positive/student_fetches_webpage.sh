#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fetch web server response
# Module: linux-networking
# Section: 05-http-with-curl
# Lab ID: lnx-fetch-webpage
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-fetch-webpage"

# Step 1: Student runs curl to fetch the homepage
student_exec "curl http://127.0.0.1:9090" \
    --desc "Student fetches homepage from mock web server" \
    --expect-exit 0 \
    --expect-stdout "welcome to thelastdeploy"

# Step 2: Student saves response body to homepage.txt
student_exec "mkdir -p ~/network-test && curl -s http://127.0.0.1:9090 > ~/network-test/homepage.txt" \
    --desc "Student saves homepage response" \
    --expect-exit 0

# Step 3: Student verifies recorded content
student_exec "cat ~/network-test/homepage.txt" \
    --desc "Student verifies recorded homepage content" \
    --expect-exit 0 \
    --expect-stdout "welcome to thelastdeploy"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Homepage content successfully retrieved."
