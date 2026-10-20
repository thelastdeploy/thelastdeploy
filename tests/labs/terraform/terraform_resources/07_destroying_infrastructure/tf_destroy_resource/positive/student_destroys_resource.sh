#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Destroy Provisioned Resource
# Module: terraform-resources
# Section: 07-destroying-infrastructure
# Lab ID: tf-destroy-resource
# ==============================================================================
set -euo pipefail

LAB_ID="tf-destroy-resource"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Ensure provisioned resource is initially applied
student_exec "cd ~/terraform-resources-challenge && ([ -f terraform.tfstate ] || (terraform init && terraform apply -auto-approve))" \
    --desc "Student ensures terraform workspace is initialized and applied" \
    --expect-exit 0

# Step 3: Student runs terraform destroy
student_exec "cd ~/terraform-resources-challenge && terraform destroy -auto-approve" \
    --desc "Student destroys terraform resources" \
    --expect-exit 0 \
    --expect-stdout "Destroy complete!"

# Step 4: Student confirms resource was destroyed
student_exec "[ ! -f /tmp/temp.txt ]" \
    --desc "Student verifies temporary file was deleted" \
    --expect-exit 0

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Resource destroyed successfully."
