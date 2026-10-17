#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Builds a Failure-Safe Script with strict mode
# Lab: lnx-build-failure-safe-script
# ==============================================================================

# Step 1: Ensure err-test directory exists
student_exec \
  --step-name "Ensure err-test directory exists" \
  --cmd "mkdir -p ~/err-test" \
  --expect-exit-code 0

# Step 2: Create safe_run.sh script
student_exec \
  --step-name "Create safe_run.sh script" \
  --cmd "cat << 'EOF' > ~/err-test/safe_run.sh
#!/bin/bash
set -euo pipefail

if [ \$# -lt 1 ] || [ -z \"\${1:-}\" ]; then
    echo \"Usage: safe_run.sh <file>\"
    exit 2
fi

echo \"Processing \$1\"
exit 0
EOF
chmod +x ~/err-test/safe_run.sh" \
  --expect-exit-code 0

# Step 3: Test execution with valid argument
student_exec \
  --step-name "Run safe_run.sh with valid file argument" \
  --cmd "~/err-test/safe_run.sh myfile.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Processing myfile.txt"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Failure-safe script verified."
