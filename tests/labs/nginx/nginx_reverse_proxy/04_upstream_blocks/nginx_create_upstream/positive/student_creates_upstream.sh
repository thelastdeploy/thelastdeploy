#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create Upstream
# Module: nginx-reverse-proxy
# Section: 04-upstream-blocks
# Lab ID: nginx-create-upstream
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-create-upstream"

# Step 1: Student creates upstream block in /etc/nginx/conf.d/upstream.conf
student_exec "cat <<'EOF' > /etc/nginx/conf.d/upstream.conf
upstream backend_servers {
    server 127.0.0.1:8001;
    server 127.0.0.1:8002;
}
EOF" \
    --desc "Student creates upstream configuration file" \
    --expect-exit 0

# Step 2: Student validates nginx configuration syntax
student_exec "nginx -t" \
    --desc "Student verifies nginx configuration syntax" \
    --expect-exit 0 \
    --expect-stderr "syntax is ok"

# Step 3: Student reloads nginx
student_exec "systemctl restart nginx" \
    --desc "Student reloads nginx service" \
    --expect-exit 0

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Upstream block correctly defined."
