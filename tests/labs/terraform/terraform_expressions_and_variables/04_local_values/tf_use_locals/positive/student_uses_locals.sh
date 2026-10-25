#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Use Local Values for DRY Code
# Module: terraform-expressions-and-variables
# Section: 04-local-values
# Lab ID: tf-use-locals
# ==============================================================================
set -euo pipefail

LAB_ID="tf-use-locals"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student updates main.tf to configure locals and reference local value
student_exec "cat << 'EOF' > ~/terraform-expr-challenge/main.tf
locals {
  env = \"production\"
}

resource \"local_file\" \"f1\" {
  content  = local.env
  filename = \"/tmp/prod_1.txt\"
}
EOF" \
    --desc "Student defines locals and references local.env in main.tf" \
    --expect-exit 0

# Step 3: Student initializes workspace and applies configuration
student_exec "cd ~/terraform-expr-challenge && terraform init && terraform apply -auto-approve" \
    --desc "Student initializes and applies configuration" \
    --expect-exit 0 \
    --expect-stdout "Apply complete!"

# Step 4: Student verifies file content
student_exec "cat /tmp/prod_1.txt" \
    --desc "Student verifies created file" \
    --expect-exit 0 \
    --expect-stdout "production"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Local values utilized successfully."
