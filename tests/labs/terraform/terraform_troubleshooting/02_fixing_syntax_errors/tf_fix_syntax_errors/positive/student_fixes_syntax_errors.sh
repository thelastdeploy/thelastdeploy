#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix Syntax Errors in Configuration
# Module: terraform-troubleshooting
# Section: 02-fixing-syntax-errors
# Lab ID: tf-fix-syntax-errors
# ==============================================================================
set -euo pipefail

LAB_ID="tf-fix-syntax-errors"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student fixes syntax by closing block and formatting
student_exec "cat << 'EOF' > ~/terraform-troubleshoot-challenge/main.tf
resource \"local_file\" \"syntax_bug\" {
  content  = \"broken syntax\"
  filename = \"/tmp/syntax.txt\"
}
EOF" \
    --desc "Student fixes unclosed block in main.tf" \
    --expect-exit 0

# Step 3: Student formats main.tf
student_exec "cd ~/terraform-troubleshoot-challenge && terraform fmt" \
    --desc "Student formats terraform configuration" \
    --expect-exit 0

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Syntax errors fixed successfully."
