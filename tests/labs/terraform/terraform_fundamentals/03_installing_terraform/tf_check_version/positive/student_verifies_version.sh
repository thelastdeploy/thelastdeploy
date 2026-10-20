#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Verify Terraform Version
# Module: terraform-fundamentals
# Section: 03-installing-terraform
# Lab ID: tf-check-version
# ==============================================================================
set -euo pipefail

LAB_ID="tf-check-version"

# Step 1: Student ensures terraform binary is present in environment
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student runs terraform -version to verify functionality
student_exec "terraform -version" \
    --desc "Student checks terraform version" \
    --expect-exit 0 \
    --expect-stdout "Terraform"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Terraform CLI is operational."
