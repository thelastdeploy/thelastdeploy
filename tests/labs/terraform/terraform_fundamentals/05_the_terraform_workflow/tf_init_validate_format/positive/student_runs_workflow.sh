#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Initialize, Validate, and Format
# Module: terraform-fundamentals
# Section: 05-the-terraform-workflow
# Lab ID: tf-init-validate-format
# ==============================================================================
set -euo pipefail

LAB_ID="tf-init-validate-format"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student initializes workspace in ~/terraform-challenge
student_exec "cd ~/terraform-challenge && terraform init" \
    --desc "Student runs terraform init" \
    --expect-exit 0

# Step 3: Student formats configurations in ~/terraform-challenge
student_exec "cd ~/terraform-challenge && terraform fmt" \
    --desc "Student runs terraform fmt" \
    --expect-exit 0

# Step 4: Student validates configuration
student_exec "cd ~/terraform-challenge && terraform validate" \
    --desc "Student runs terraform validate" \
    --expect-exit 0 \
    --expect-stdout "Success!"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration validated and formatted successfully."
