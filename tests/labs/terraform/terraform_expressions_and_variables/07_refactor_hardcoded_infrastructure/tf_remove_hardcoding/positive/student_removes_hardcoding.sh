#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Refactor Hardcoded Configuration
# Module: terraform-expressions-and-variables
# Section: 07-refactor-hardcoded-infrastructure
# Lab ID: tf-remove-hardcoding
# ==============================================================================
set -euo pipefail

LAB_ID="tf-remove-hardcoding"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student refactors main.tf to replace hardcoded value with a variable
student_exec "cat << 'EOF' > ~/terraform-expr-challenge/main.tf
variable \"file_content\" {
  type    = string
  default = \"dynamic_value_123\"
}

resource \"local_file\" \"f1\" {
  content  = var.file_content
  filename = \"/tmp/hardcoded.txt\"
}
EOF" \
    --desc "Student replaces hardcoded string with variable in main.tf" \
    --expect-exit 0

# Step 3: Student initializes workspace and validates configuration
student_exec "cd ~/terraform-expr-challenge && terraform init && terraform validate" \
    --desc "Student initializes and validates refactored configuration" \
    --expect-exit 0 \
    --expect-stdout "Success! The configuration is valid."

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Hardcoded configuration refactored and validated successfully."
