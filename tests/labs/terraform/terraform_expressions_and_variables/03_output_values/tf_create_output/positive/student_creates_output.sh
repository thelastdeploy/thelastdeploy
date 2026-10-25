#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create an Output Value
# Module: terraform-expressions-and-variables
# Section: 03-output-values
# Lab ID: tf-create-output
# ==============================================================================
set -euo pipefail

LAB_ID="tf-create-output"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student updates main.tf to append output block
student_exec "cat << 'EOF' >> ~/terraform-expr-challenge/main.tf

output \"file_content\" {
  value = local_file.out.content
}
EOF" \
    --desc "Student adds output block to main.tf" \
    --expect-exit 0

# Step 3: Student initializes workspace and applies configuration
student_exec "cd ~/terraform-expr-challenge && terraform init && terraform apply -auto-approve" \
    --desc "Student runs terraform init and apply" \
    --expect-exit 0 \
    --expect-stdout "Apply complete!"

# Step 4: Student queries output with terraform output
student_exec "cd ~/terraform-expr-challenge && terraform output -raw file_content" \
    --desc "Student inspects terraform output" \
    --expect-exit 0 \
    --expect-stdout "Output content"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Output value created and verified."
