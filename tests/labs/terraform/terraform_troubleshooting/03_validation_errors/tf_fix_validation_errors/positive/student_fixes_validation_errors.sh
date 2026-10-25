#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix Validation Errors
# Module: terraform-troubleshooting
# Section: 03-validation-errors
# Lab ID: tf-fix-validation-errors
# ==============================================================================
set -euo pipefail

LAB_ID="tf-fix-validation-errors"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student replaces invalid_param with content attribute
student_exec "cat << 'EOF' > ~/terraform-troubleshoot-challenge/main.tf
provider \"local\" {}

resource \"local_file\" \"val_bug\" {
  content  = \"test\"
  filename = \"/tmp/val.txt\"
}
EOF" \
    --desc "Student fixes invalid parameter in main.tf" \
    --expect-exit 0

# Step 3: Student initializes workspace if needed and runs terraform validate
student_exec "cd ~/terraform-troubleshoot-challenge && ([ -d .terraform ] || terraform init) && terraform validate" \
    --desc "Student runs terraform validate" \
    --expect-exit 0 \
    --expect-stdout "Success! The configuration is valid."

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Validation errors resolved."
