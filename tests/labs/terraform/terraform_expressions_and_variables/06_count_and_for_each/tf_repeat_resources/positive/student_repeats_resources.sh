#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Repeat Resources with count or for_each
# Module: terraform-expressions-and-variables
# Section: 06-count-and-for-each
# Lab ID: tf-repeat-resources
# ==============================================================================
set -euo pipefail

LAB_ID="tf-repeat-resources"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student creates main.tf using count meta-argument
student_exec "cat << 'EOF' > ~/terraform-expr-challenge/main.tf
resource \"local_file\" \"servers\" {
  count    = 2
  content  = \"Server number \${count.index}\"
  filename = \"/tmp/server_\${count.index}.txt\"
}
EOF" \
    --desc "Student creates main.tf with count meta-argument" \
    --expect-exit 0

# Step 3: Student initializes workspace and applies configuration
student_exec "cd ~/terraform-expr-challenge && terraform init && terraform apply -auto-approve" \
    --desc "Student initializes and applies configuration" \
    --expect-exit 0 \
    --expect-stdout "Apply complete!"

# Step 4: Student verifies generated files
student_exec "cat /tmp/server_0.txt && cat /tmp/server_1.txt" \
    --desc "Student verifies repeated file contents" \
    --expect-exit 0 \
    --expect-stdout "Server number 1"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Resource repetition validated successfully."
