#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create a Child Module
# Module: terraform-modules
# Section: 02-creating-your-first-module
# Lab ID: tf-create-module
# ==============================================================================
set -euo pipefail

LAB_ID="tf-create-module"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student creates child module directory and main.tf
student_exec "mkdir -p ~/terraform-modules-challenge/modules/file_writer && cat << 'EOF' > ~/terraform-modules-challenge/modules/file_writer/main.tf
resource \"local_file\" \"output\" {
  content  = \"Created by file_writer child module\"
  filename = \"/tmp/module_output.txt\"
}
EOF" \
    --desc "Student creates child module directory and main.tf" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Child module created successfully."
