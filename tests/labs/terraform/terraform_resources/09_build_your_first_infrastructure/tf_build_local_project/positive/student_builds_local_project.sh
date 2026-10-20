#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Build local infrastructure project
# Module: terraform-resources
# Section: 09-build-your-first-infrastructure
# Lab ID: tf-build-local-project
# ==============================================================================
set -euo pipefail

LAB_ID="tf-build-local-project"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student creates main.tf with multiple resources
student_exec "cat << 'EOF' > ~/terraform-resources-challenge/main.tf
resource \"local_file\" \"config\" {
  content  = \"app_env=production\nlog_level=info\"
  filename = \"/tmp/config.env\"
}

resource \"local_file\" \"status\" {
  content  = \"status=ready\"
  filename = \"/tmp/status.txt\"
}
EOF" \
    --desc "Student writes multi-resource configuration in main.tf" \
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

# Step 5: Student verifies provisioned files
student_exec "cat /tmp/config.env && cat /tmp/status.txt" \
    --desc "Student verifies created files exist" \
    --expect-exit 0 \
    --expect-stdout "status=ready"

# Step 6: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Local infrastructure project successfully provisioned and verified."
