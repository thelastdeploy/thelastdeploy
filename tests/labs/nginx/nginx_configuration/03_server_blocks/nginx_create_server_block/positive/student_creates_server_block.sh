#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create Server Block
# Module: nginx-configuration
# Section: 03-server-blocks
# Lab ID: nginx-create-server-block
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-create-server-block"

# Step 1: Student ensures sites-available directory exists
student_exec "mkdir -p /etc/nginx/sites-available" \
    --desc "Student ensures /etc/nginx/sites-available directory exists" \
    --expect-exit 0

# Step 2: Student creates mysite server block configuration
student_exec "cat << 'EOF' > /etc/nginx/sites-available/mysite
server {
    listen 8080;
    server_name mysite.local;
    root /var/www/mysite;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF" \
    --desc "Student writes server block configuration for mysite" \
    --expect-exit 0

# Step 3: Student verifies file content
student_exec "cat /etc/nginx/sites-available/mysite" \
    --desc "Student inspects created server block file" \
    --expect-exit 0 \
    --expect-stdout "mysite.local"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Server block 'mysite' correctly created and configured."
