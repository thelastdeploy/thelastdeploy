#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Initialize a Terraform Project
# Module: terraform-fundamentals
# Section: 04-your-first-terraform-project
# Lab ID: tf-init-project
# ==============================================================================
set -euo pipefail

LAB_ID="tf-init-project"

# Step 1: Ensure terraform is present in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student initializes workspace in ~/terraform-challenge
student_exec "cd ~/terraform-challenge && terraform init" \
    --desc "Student runs terraform init" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Terraform workspace initialized successfully."
