#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Use a terraform.tfvars File
# Module: terraform-expressions-and-variables
# Section: 02-variable-files
# Lab ID: tf-use-tfvars
# ==============================================================================
set -euo pipefail

LAB_ID="tf-use-tfvars"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student creates terraform.tfvars file
student_exec "cat << 'EOF' > ~/terraform-expr-challenge/terraform.tfvars
filename = \"/tmp/tfvars_output.txt\"
EOF" \
    --desc "Student creates terraform.tfvars" \
    --expect-exit 0

# Step 3: Student initializes workspace and applies configuration
student_exec "cd ~/terraform-expr-challenge && terraform init && terraform apply -auto-approve" \
    --desc "Student initializes and applies configuration" \
    --expect-exit 0 \
    --expect-stdout "Apply complete!"

# Step 4: Student verifies generated file
student_exec "cat /tmp/tfvars_output.txt" \
    --desc "Student verifies generated file content" \
    --expect-exit 0 \
    --expect-stdout "hello"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: terraform.tfvars configuration applied successfully."
