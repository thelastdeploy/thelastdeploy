#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Access Output Values from a Module
# Module: terraform-modules
# Section: 03-module-inputs-and-outputs
# Lab ID: tf-module-outputs
# ==============================================================================
set -euo pipefail

LAB_ID="tf-module-outputs"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student appends output referencing module output in main.tf
student_exec "cat << 'EOF' >> ~/terraform-modules-challenge/main.tf

output \"written_file\" {
  value = module.writer.file_path
}
EOF" \
    --desc "Student references module.writer.file_path in main.tf" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Module output value accessed successfully."
