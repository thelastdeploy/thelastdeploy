#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a Random Resource
# Module: terraform-resources
# Section: 02-resources
# Lab ID: tf-create-random-resource
# ==============================================================================
set -euo pipefail

LAB_ID="tf-create-random-resource"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student adds random_id resource block to main.tf
student_exec "cat << 'EOF' > ~/terraform-resources-challenge/main.tf
provider \"random\" {}

resource \"random_id\" \"server\" {
  byte_length = 8
}
EOF" \
    --desc "Student writes random_id resource in main.tf" \
    --expect-exit 0

# Step 3: Student initializes workspace
student_exec "cd ~/terraform-resources-challenge && terraform init" \
    --desc "Student runs terraform init" \
    --expect-exit 0

# Step 4: Student applies configuration
student_exec "cd ~/terraform-resources-challenge && terraform apply -auto-approve" \
    --desc "Student runs terraform apply" \
    --expect-exit 0 \
    --expect-stdout "Apply complete!"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Random resource created and verified."
