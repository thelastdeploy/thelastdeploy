#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Recover Broken Infrastructure Project
# Module: terraform-troubleshooting
# Section: 09-recover-a-broken-infrastructure-project
# Lab ID: tf-production-recovery
# ==============================================================================
set -euo pipefail

LAB_ID="tf-production-recovery"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Ensure seed setup is present
student_exec "mkdir -p ~/terraform-troubleshoot-challenge && cat << 'EOF' > ~/terraform-troubleshoot-challenge/main.tf
resource \"local_file\" \"prod\" {
  content  = \"Production system\"
  filename = \"/tmp/prod_rec.txt\"
  bad_attr = 123
}
EOF" \
    --desc "Student verifies seed state" \
    --expect-exit 0

# Step 3: Remove invalid attribute from main.tf
student_exec "cat << 'EOF' > ~/terraform-troubleshoot-challenge/main.tf
resource \"local_file\" \"prod\" {
  content  = \"Production system\"
  filename = \"/tmp/prod_rec.txt\"
}
EOF" \
    --desc "Student removes invalid attribute from main.tf" \
    --expect-exit 0

# Step 4: Initialize terraform workspace
student_exec "cd ~/terraform-troubleshoot-challenge && terraform init" \
    --desc "Student initializes workspace" \
    --expect-exit 0 \
    --expect-stdout "Terraform has been successfully initialized!"

# Step 5: Validate configuration
student_exec "cd ~/terraform-troubleshoot-challenge && terraform validate" \
    --desc "Student validates configuration" \
    --expect-exit 0 \
    --expect-stdout "Success! The configuration is valid."

# Step 6: Apply configuration to restore infrastructure
student_exec "cd ~/terraform-troubleshoot-challenge && terraform apply -auto-approve" \
    --desc "Student applies configuration" \
    --expect-exit 0 \
    --expect-stdout "Apply complete!"

# Step 7: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Production infrastructure project recovered and verified successfully."
