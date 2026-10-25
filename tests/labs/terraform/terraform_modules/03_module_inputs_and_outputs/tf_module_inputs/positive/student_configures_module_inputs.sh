#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Pass Input Arguments to a Module
# Module: terraform-modules
# Section: 03-module-inputs-and-outputs
# Lab ID: tf-module-inputs
# ==============================================================================
set -euo pipefail

LAB_ID="tf-module-inputs"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student updates main.tf to pass text argument to module writer
student_exec "cat << 'EOF' > ~/terraform-modules-challenge/main.tf
module \"writer\" {
  source = \"./modules/file_writer\"
  text   = \"Hello from root module\"
}
EOF" \
    --desc "Student configures module input argument in main.tf" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Module input arguments configured successfully."
