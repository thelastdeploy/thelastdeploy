#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Format Your Resource Configuration
# Module: terraform-hcl
# Section: 03-writing-your-first-resource
# Lab ID: tf-format-resource
# ==============================================================================
set -euo pipefail

LAB_ID="tf-format-resource"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student formats configurations in ~/terraform-hcl-challenge
student_exec "cd ~/terraform-hcl-challenge && terraform fmt" \
    --desc "Student formats terraform configuration" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration formatted successfully."
