#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Use Built-in String Functions
# Module: terraform-expressions-and-variables
# Section: 05-built-in-functions
# Lab ID: tf-string-functions
# ==============================================================================
set -euo pipefail

LAB_ID="tf-string-functions"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student updates main.tf to use a string function in an output
student_exec "cat << 'EOF' >> ~/terraform-expr-challenge/main.tf

output \"clean_text\" {
  value = trimspace(var.raw_text)
}
EOF" \
    --desc "Student adds output using trimspace() string function" \
    --expect-exit 0

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Built-in string function verified."
