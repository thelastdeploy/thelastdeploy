#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Request Variables
# Module: nginx-routing
# Section: 05-request-variables
# Lab ID: nginx-request-variables
# ==============================================================================
set -euo pipefail

LAB_ID="nginx-request-variables"

# Step 1: Student adds location /info interpolating $http_user_agent
student_exec "sed -i '/server_name _;/a \\\tlocation /info {\\n\\t\\tdefault_type text/plain;\\n\\t\\treturn 200 \"Agent: \\\$http_user_agent\";\\n\\t}' /etc/nginx/sites-available/default" \
    --desc "Student adds /info location with User-Agent variable interpolation" \
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

# Step 4: Student queries /info with a custom User-Agent
student_exec "curl -s -H 'User-Agent: MyCustomAgent' http://localhost/info" \
    --desc "Student verifies User-Agent echo response" \
    --expect-exit 0 \
    --expect-stdout "Agent: MyCustomAgent"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Nginx variable interpolation configured successfully."
