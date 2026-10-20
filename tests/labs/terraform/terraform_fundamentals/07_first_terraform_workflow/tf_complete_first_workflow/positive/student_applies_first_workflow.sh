#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Complete the First Terraform Workflow
# Module: terraform-fundamentals
# Section: 07-first-terraform-workflow
# Lab ID: tf-complete-first-workflow
# ==============================================================================
set -euo pipefail

LAB_ID="tf-complete-first-workflow"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student initializes workspace in ~/terraform-challenge
student_exec "cd ~/terraform-challenge && terraform init" \
    --desc "Student runs terraform init" \
    --expect-exit 0

# Step 3: Student runs terraform plan
student_exec "cd ~/terraform-challenge && terraform plan" \
    --desc "Student runs terraform plan" \
    --expect-exit 0

# Step 4: Student applies terraform configuration
student_exec "cd ~/terraform-challenge && terraform apply -auto-approve" \
    --desc "Student applies configuration" \
    --expect-exit 0 \
    --expect-stdout "Apply complete!"

# Step 5: Student inspects generated file
student_exec "cat /tmp/pet.txt" \
    --desc "Student verifies created file content" \
    --expect-exit 0 \
    --expect-stdout "We love pets!"

# Step 6: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Successfully initialized, planned, and applied first Terraform workflow."
