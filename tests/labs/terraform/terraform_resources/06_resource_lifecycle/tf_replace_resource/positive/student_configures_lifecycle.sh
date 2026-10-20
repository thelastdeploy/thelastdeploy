#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Configure Resource replacement lifecycle
# Module: terraform-resources
# Section: 06-resource-lifecycle
# Lab ID: tf-replace-resource
# ==============================================================================
set -euo pipefail

LAB_ID="tf-replace-resource"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student updates main.tf to configure lifecycle create_before_destroy
student_exec "cat << 'EOF' > ~/terraform-resources-challenge/main.tf
resource \"local_file\" \"example\" {
  content  = \"Lifecycle test\"
  filename = \"/tmp/lifecycle.txt\"

  lifecycle {
    create_before_destroy = true
  }
}
EOF" \
    --desc "Student configures lifecycle block in main.tf" \
    --expect-exit 0

# Step 3: Student initializes workspace and applies configuration
student_exec "cd ~/terraform-resources-challenge && terraform init && terraform apply -auto-approve" \
    --desc "Student runs terraform init and apply" \
    --expect-exit 0 \
    --expect-stdout "Apply complete!"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Resource lifecycle configuration verified."
