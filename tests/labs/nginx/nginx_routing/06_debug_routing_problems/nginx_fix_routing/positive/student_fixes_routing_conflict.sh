#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix Routing Conflict
# Module: nginx-routing
# Section: 06-debug-routing-problems
# Lab ID: nginx-fix-routing
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-fix-routing"

# Step 1: Student inspects the initial routing conflict returning 'pdf report'
student_exec "curl -s http://localhost/documents/report.pdf" \
    --desc "Student observes regex block overriding prefix block" \
    --expect-exit 0 \
    --expect-stdout "pdf report"

# Step 2: Student adds ^~ modifier to /documents/ location block to prevent regex matching
student_exec "sed -i 's/location \\/documents\\//location ^~ \\/documents\\//' /etc/nginx/sites-available/default" \
    --desc "Student updates /documents/ location with ^~ modifier" \
    --expect-exit 0

# Step 3: Student validates nginx configuration syntax
student_exec "nginx -t" \
    --desc "Student verifies nginx configuration syntax" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 4: Student reloads nginx
student_exec "systemctl restart nginx" \
    --desc "Student reloads nginx service" \
    --expect-exit 0

# Step 5: Student queries /documents/report.pdf and verifies prefix block now serves 'docs report'
student_exec "curl -s http://localhost/documents/report.pdf" \
    --desc "Student verifies /documents/ block takes precedence over regex" \
    --expect-exit 0 \
    --expect-stdout "docs report"

# Step 6: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Routing conflict fixed successfully."
