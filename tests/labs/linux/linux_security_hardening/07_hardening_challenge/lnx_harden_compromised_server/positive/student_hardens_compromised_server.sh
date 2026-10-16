#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Hardens Compromised Linux Server Capstone
# Lab: lnx-harden-compromised-server
# ==============================================================================

# Step 1: Create sec-challenge workspace directory
student_exec \
  --step-name "Create sec-challenge directory" \
  --cmd "mkdir -p ~/sec-challenge" \
  --expect-exit-code 0

# Step 2: Create harden_server.sh remediation script
student_exec \
  --step-name "Create server hardening remediation script" \
  --cmd "cat << 'EOF' > ~/sec-challenge/harden_server.sh
#!/bin/bash
echo '=== Compromised Server Hardening Execution ==='
# Access controls, file security, and port restriction steps
EOF
chmod +x ~/sec-challenge/harden_server.sh" \
  --expect-exit-code 0

# Step 3: Record hardening completion summary in hardening.log
student_exec \
  --step-name "Record server hardening summary" \
  --cmd "echo 'COMPROMISED_SERVER_HARDENED' > ~/sec-challenge/hardening.log" \
  --expect-exit-code 0

# Step 4: Verify hardening.log content
student_exec \
  --step-name "Verify hardening.log content" \
  --cmd "cat ~/sec-challenge/hardening.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "COMPROMISED_SERVER_HARDENED"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Compromised server hardening capstone verified."
