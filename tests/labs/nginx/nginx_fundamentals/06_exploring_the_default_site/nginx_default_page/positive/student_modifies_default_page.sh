#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Modify Default Site Page
# Module: nginx-fundamentals
# Section: 06-exploring-the-default-site
# Lab ID: nginx-default-page
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-default-page"

# Step 1: Student ensures nginx package is installed in test container and running
student_exec "which nginx || (apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nginx)" \
    --desc "Student ensures nginx package is installed in test container" \
    --expect-exit 0

student_exec "systemctl start nginx || true" \
    --desc "Student ensures nginx service is active" \
    --expect-exit 0

# Step 2: Student inspects initial default page
student_exec "cat /var/www/html/index.html" \
    --desc "Student views initial index.html content" \
    --expect-exit 0

# Step 3: Student modifies /var/www/html/index.html to contain required heading
student_exec "echo '<h1>Hello from The Last Deploy</h1>' > /var/www/html/index.html" \
    --desc "Student modifies index.html with greeting" \
    --expect-exit 0

# Step 4: Student verifies index.html content
student_exec "grep -i 'Hello from The Last Deploy' /var/www/html/index.html" \
    --desc "Student verifies index.html contains greeting" \
    --expect-exit 0 \
    --expect-stdout "Hello from The Last Deploy"

# Step 5: Student tests web server response locally
student_exec "curl -s http://localhost/" \
    --desc "Student fetches homepage from local nginx server" \
    --expect-exit 0 \
    --expect-stdout "Hello from The Last Deploy"

# Step 6: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Default page successfully modified and served by Nginx."
