#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Update Resource Arguments
# Module: terraform-resources
# Section: 03-resource-arguments
# Lab ID: tf-update-resource
# ==============================================================================
set -euo pipefail

LAB_ID="tf-update-resource"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student updates content argument in main.tf from v1 to v2
student_exec "sed -i 's/content = \"v1\"/content = \"v2\"/' ~/terraform-resources-challenge/main.tf" \
    --desc "Student updates content argument in main.tf" \
    --expect-exit 0

# Step 3: Student initializes workspace
student_exec "cd ~/terraform-resources-challenge && terraform init" \
    --desc "Student runs terraform init" \
    --expect-exit 0

# Step 4: Student applies updated configuration
student_exec "cd ~/terraform-resources-challenge && terraform apply -auto-approve" \
    --desc "Student runs terraform apply" \
    --expect-exit 0 \
    --expect-stdout "Apply complete!"

# Step 5: Student inspects updated file
student_exec "cat /tmp/app.txt" \
    --desc "Student verifies updated file content" \
    --expect-exit 0 \
    --expect-stdout "v2"

# Step 6: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Resource argument updated and applied successfully."
