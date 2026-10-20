#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Read from a Data Source
# Module: terraform-resources
# Section: 05-data-sources
# Lab ID: tf-read-data-source
# ==============================================================================
set -euo pipefail

LAB_ID="tf-read-data-source"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student creates main.tf declaring data source and local_file resource
student_exec "cat << 'EOF' > ~/terraform-resources-challenge/main.tf
data \"local_file\" \"external\" {
  filename = \"/tmp/external.txt\"
}

resource \"local_file\" \"copy\" {
  content  = data.local_file.external.content
  filename = \"/tmp/copy.txt\"
}
EOF" \
    --desc "Student writes data source and dependent resource block in main.tf" \
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

# Step 5: Student inspects copied file
student_exec "cat /tmp/copy.txt" \
    --desc "Student verifies copied file content" \
    --expect-exit 0 \
    --expect-stdout "Hello from external source!"

# Step 6: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Data source read and applied successfully."
