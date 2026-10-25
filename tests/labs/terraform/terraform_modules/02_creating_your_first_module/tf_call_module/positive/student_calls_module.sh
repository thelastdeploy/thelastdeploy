#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Call a Child Module from Root
# Module: terraform-modules
# Section: 02-creating-your-first-module
# Lab ID: tf-call-module
# ==============================================================================
set -euo pipefail

LAB_ID="tf-call-module"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student adds module block in root main.tf
student_exec "cat << 'EOF' > ~/terraform-modules-challenge/main.tf
module \"file_writer\" {
  source = \"./modules/file_writer\"
}
EOF" \
    --desc "Student calls child module in main.tf" \
    --expect-exit 0

# Step 3: Student initializes workspace to register child module
student_exec "cd ~/terraform-modules-challenge && terraform init" \
    --desc "Student runs terraform init" \
    --expect-exit 0 \
    --expect-stdout "Terraform has been successfully initialized!"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Child module called and initialized successfully."
