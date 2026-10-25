#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix Module Invocation Errors
# Module: terraform-troubleshooting
# Section: 07-module-errors
# Lab ID: tf-fix-module
# ==============================================================================
set -euo pipefail

LAB_ID="tf-fix-module"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Ensure seed setup is present
student_exec "mkdir -p ~/terraform-troubleshoot-challenge/modules/sub && echo 'variable \"val\" { type = string }' > ~/terraform-troubleshoot-challenge/modules/sub/variables.tf && echo -e 'resource \"local_file\" \"m\" { content = var.val \n filename = \"/tmp/sub.txt\" }' > ~/terraform-troubleshoot-challenge/modules/sub/main.tf && cd ~/terraform-troubleshoot-challenge && ([ -d .terraform ] || terraform init)" \
    --desc "Student ensures workspace and module are initialized" \
    --expect-exit 0

# Step 3: Pass required val argument in root main.tf
student_exec "cat << 'EOF' > ~/terraform-troubleshoot-challenge/main.tf
module \"sub_call\" {
  source = \"./modules/sub\"
  val    = \"hello\"
}
EOF" \
    --desc "Student passes required val argument to module in main.tf" \
    --expect-exit 0

# Step 4: Validate configuration
student_exec "cd ~/terraform-troubleshoot-challenge && terraform validate" \
    --desc "Student validates configuration" \
    --expect-exit 0 \
    --expect-stdout "Success! The configuration is valid."

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Module invocation error resolved."
