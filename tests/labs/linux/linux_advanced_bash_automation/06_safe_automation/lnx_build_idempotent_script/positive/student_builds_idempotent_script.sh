#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Builds an Idempotent Automation Script
# Lab: lnx-build-idempotent-script
# ==============================================================================

# Step 1: Ensure idempotent-test directory exists and seed initial app.conf
student_exec \
  --step-name "Ensure directory exists and seed app.conf" \
  --cmd "mkdir -p ~/idempotent-test && echo 'MAX_CONNECTIONS=100' > ~/idempotent-test/app.conf" \
  --expect-exit-code 0

# Step 2: Create deploy.sh script
student_exec \
  --step-name "Create deploy.sh script" \
  --cmd "cat << 'EOF' > ~/idempotent-test/deploy.sh
#!/bin/bash
set -euo pipefail

CONF=\"\$HOME/idempotent-test/app.conf\"

if grep -q \"^MAX_CONNECTIONS=\" \"\$CONF\"; then
    sed -i 's/^MAX_CONNECTIONS=.*/MAX_CONNECTIONS=200/' \"\$CONF\"
else
    echo \"MAX_CONNECTIONS=200\" >> \"\$CONF\"
fi

if ! grep -q \"^TIMEOUT=\" \"\$CONF\"; then
    echo \"TIMEOUT=30\" >> \"\$CONF\"
fi
EOF
chmod +x ~/idempotent-test/deploy.sh" \
  --expect-exit-code 0

# Step 3: Execute deploy.sh twice to verify idempotency
student_exec \
  --step-name "Execute deploy.sh twice" \
  --cmd "~/idempotent-test/deploy.sh && ~/idempotent-test/deploy.sh" \
  --expect-exit-code 0

# Step 4: Verify app.conf contents
student_exec \
  --step-name "Verify app.conf contents" \
  --cmd "cat ~/idempotent-test/app.conf" \
  --expect-exit-code 0 \
  --expect-stdout-contains "MAX_CONNECTIONS=200"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Idempotent configuration script verified."
