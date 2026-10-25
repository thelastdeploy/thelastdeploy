#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Define Variable Default Values
# Module: terraform-expressions-and-variables
# Section: 02-variable-files
# Lab ID: tf-default-values
# ==============================================================================
set -euo pipefail

LAB_ID="tf-default-values"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student updates main.tf to configure default attribute
student_exec "cat << 'EOF' > ~/terraform-expr-challenge/main.tf
variable \"app_name\" {
  type    = string
  default = \"my-awesome-app\"
}
EOF" \
    --desc "Student defines default value in main.tf" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Default value defined successfully."
