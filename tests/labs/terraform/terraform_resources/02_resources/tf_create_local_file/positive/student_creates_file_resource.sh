#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a Local File Resource
# Module: terraform-resources
# Section: 02-resources
# Lab ID: tf-create-local-file
# ==============================================================================
set -euo pipefail

LAB_ID="tf-create-local-file"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student creates main.tf with local_file resource block
student_exec "cat << 'EOF' > ~/terraform-resources-challenge/main.tf
resource \"local_file\" \"welcome\" {
  content  = \"Terraform resource demonstration\"
  filename = \"/tmp/welcome.txt\"
}
EOF" \
    --desc "Student writes local_file resource block in main.tf" \
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
    --expect-stdout "PASS: Local file resource created successfully."
