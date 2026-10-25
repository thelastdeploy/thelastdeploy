#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Refactor Monolithic Project into Modules
# Module: terraform-modules
# Section: 06-refactor-a-project-into-modules
# Lab ID: tf-refactor-project
# ==============================================================================
set -euo pipefail

LAB_ID="tf-refactor-project"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student creates modules/files child module and moves resources
student_exec "mkdir -p ~/terraform-modules-challenge/modules/files && cat << 'EOF' > ~/terraform-modules-challenge/modules/files/main.tf
resource \"local_file\" \"f1\" {
  content  = \"1\"
  filename = \"/tmp/f1.txt\"
}

resource \"local_file\" \"f2\" {
  content  = \"2\"
  filename = \"/tmp/f2.txt\"
}
EOF" \
    --desc "Student creates child module modules/files" \
    --expect-exit 0

# Step 3: Student refactors root main.tf to invoke child module
student_exec "cat << 'EOF' > ~/terraform-modules-challenge/main.tf
module \"files\" {
  source = \"./modules/files\"
}
EOF" \
    --desc "Student calls child module from root main.tf" \
    --expect-exit 0

# Step 4: Student initializes workspace and validates project
student_exec "cd ~/terraform-modules-challenge && terraform init && terraform validate" \
    --desc "Student initializes and validates refactored modular project" \
    --expect-exit 0 \
    --expect-stdout "Success! The configuration is valid."

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Monolithic project refactored into modules successfully."
