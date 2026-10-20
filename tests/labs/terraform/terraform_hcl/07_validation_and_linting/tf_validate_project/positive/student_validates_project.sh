#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Validate a Terraform Project
# Module: terraform-hcl
# Section: 07-validation-and-linting
# Lab ID: tf-validate-project
# ==============================================================================
set -euo pipefail

LAB_ID="tf-validate-project"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student initializes workspace in ~/terraform-hcl-challenge
student_exec "cd ~/terraform-hcl-challenge && terraform init" \
    --desc "Student runs terraform init" \
    --expect-exit 0

# Step 3: Student validates configuration
student_exec "cd ~/terraform-hcl-challenge && terraform validate" \
    --desc "Student runs terraform validate" \
    --expect-exit 0 \
    --expect-stdout "Success!"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Project is initialized and validated successfully."
