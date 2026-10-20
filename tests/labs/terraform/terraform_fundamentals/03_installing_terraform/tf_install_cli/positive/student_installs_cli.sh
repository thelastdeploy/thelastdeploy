#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Install Terraform CLI
# Module: terraform-fundamentals
# Section: 03-installing-terraform
# Lab ID: tf-install-cli
# ==============================================================================
set -euo pipefail

LAB_ID="tf-install-cli"

# Step 1: Student installs terraform executable into PATH
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student installs terraform binary" \
    --expect-exit 0

# Step 2: Student verifies terraform executable location
student_exec "which terraform" \
    --desc "Student verifies terraform binary location" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Terraform CLI successfully found."
