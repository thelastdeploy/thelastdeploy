#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Builds Production Automation Tool Capstone
# Lab: lnx-build-production-automation
# ==============================================================================

# Step 1: Ensure bash-challenge directory exists
student_exec \
  --step-name "Ensure directory exists" \
  --cmd "mkdir -p ~/bash-challenge" \
  --expect-exit-code 0

# Step 2: Create production_tool.sh script
student_exec \
  --step-name "Create production_tool.sh script" \
  --cmd "cat << 'EOF' > ~/bash-challenge/production_tool.sh
#!/bin/bash
set -euo pipefail

LOCK=\"\$HOME/bash-challenge/temp.lock\"
STATUS=\"\$HOME/bash-challenge/status.log\"
ENV_FILE=\"\$HOME/bash-challenge/app.env\"

cleanup() {
    rm -f \"\$LOCK\"
}
trap cleanup EXIT

touch \"\$LOCK\"

log_info() {
    echo \"[INFO] \$1\"
}

log_error() {
    echo \"[ERROR] \$1\" >&2
}

log_info \"Initializing production tool\"

cat << 'ENVEOF' > \"\$ENV_FILE\"
ENV=production
VERSION=2.0
ENVEOF

echo \"PRODUCTION_AUTOMATION_COMPLETE\" >> \"\$STATUS\"
log_info \"Production automation completed successfully\"
EOF
chmod +x ~/bash-challenge/production_tool.sh" \
  --expect-exit-code 0

# Step 3: Execute production_tool.sh
student_exec \
  --step-name "Execute production_tool.sh" \
  --cmd "~/bash-challenge/production_tool.sh" \
  --expect-exit-code 0

# Step 4: Verify status and env file
student_exec \
  --step-name "Verify generated files" \
  --cmd "cat ~/bash-challenge/status.log && cat ~/bash-challenge/app.env" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PRODUCTION_AUTOMATION_COMPLETE"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Production automation capstone tool verified."
