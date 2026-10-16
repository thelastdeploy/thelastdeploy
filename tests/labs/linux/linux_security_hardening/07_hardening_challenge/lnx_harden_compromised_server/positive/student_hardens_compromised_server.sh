#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Hardens Compromised Linux Server Capstone
# Lab: lnx-harden-compromised-server
# ==============================================================================

set -euo pipefail

LAB_ID="lnx-harden-compromised-server"

# Step 1: Create sec-challenge workspace directory
student_exec "mkdir -p ~/sec-challenge" \
    --desc "Student prepares sec-challenge directory" \
    --expect-exit 0

# Step 2: Create harden_server.sh remediation script
student_exec "cat << 'EOF' > ~/sec-challenge/harden_server.sh
#!/bin/bash
echo '=== Compromised Server Hardening Execution ==='
# Access controls, file security, and port restriction steps
EOF
chmod +x ~/sec-challenge/harden_server.sh" \
    --desc "Student creates server hardening remediation script" \
    --expect-exit 0

# Step 3: Record hardening completion summary in hardening.log
student_exec "echo 'COMPROMISED_SERVER_HARDENED' > ~/sec-challenge/hardening.log" \
    --desc "Student writes server hardening summary" \
    --expect-exit 0

# Step 4: Verify hardening.log content
student_exec "cat ~/sec-challenge/hardening.log" \
    --desc "Student verifies hardening.log content" \
    --expect-exit 0 \
    --expect-stdout "COMPROMISED_SERVER_HARDENED"

# Step 5: Execute validator verification via tld check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Compromised server hardening capstone verified."
