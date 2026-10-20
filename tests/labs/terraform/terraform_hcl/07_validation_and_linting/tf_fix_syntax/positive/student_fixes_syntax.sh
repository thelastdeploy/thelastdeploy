#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix HCL Syntax Errors
# Module: terraform-hcl
# Section: 07-validation-and-linting
# Lab ID: tf-fix-syntax
# ==============================================================================
set -euo pipefail

LAB_ID="tf-fix-syntax"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student appends missing closing brace to main.tf
student_exec "echo '}' >> ~/terraform-hcl-challenge/main.tf" \
    --desc "Student fixes syntax by appending closing brace" \
    --expect-exit 0

# Step 3: Student initializes and validates configuration
student_exec "cd ~/terraform-hcl-challenge && terraform init && terraform validate" \
    --desc "Student initializes and validates configuration" \
    --expect-exit 0 \
    --expect-stdout "Success!"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Syntax errors fixed and configuration validated."
