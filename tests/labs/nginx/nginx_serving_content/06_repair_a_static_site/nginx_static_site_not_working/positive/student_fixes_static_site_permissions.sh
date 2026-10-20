#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Repair Blocked Static Page
# Module: nginx-serving-content
# Section: 06-repair-a-static-site
# Lab ID: nginx-static-site-not-working
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-static-site-not-working"

# Step 1: Student inspects the initial permission issue and confirms 403 Forbidden
student_exec "curl -i -s http://localhost/" \
    --desc "Student observes 403 Forbidden due to restricted permissions" \
    --expect-exit 0 \
    --expect-stdout "403 Forbidden"

# Step 2: Student fixes permissions on /var/www/html
student_exec "chmod 755 /var/www/html" \
    --desc "Student restores 755 permissions on web root directory" \
    --expect-exit 0

# Step 3: Student verifies static page now returns 200 OK
student_exec "curl -i -s http://localhost/" \
    --desc "Student verifies static welcome page returns 200 OK" \
    --expect-exit 0 \
    --expect-stdout "200 OK"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Directory permissions fixed and static welcome page successfully served."
