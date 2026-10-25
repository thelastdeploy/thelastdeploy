#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Fix Resource Reference Typos
# Module: terraform-troubleshooting
# Section: 05-resource-reference-errors
# Lab ID: tf-fix-resource-references
# ==============================================================================
set -euo pipefail

LAB_ID="tf-fix-resource-references"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Student fixes typo in resource reference
student_exec "cat << 'EOF' > ~/terraform-troubleshoot-challenge/main.tf
resource \"local_file\" \"target_file\" {
  content  = \"target\"
  filename = \"/tmp/target.txt\"
}

resource \"local_file\" \"reader\" {
  content  = local_file.target_file.filename
  filename = \"/tmp/reader.txt\"
}
EOF" \
    --desc "Student updates resource reference to target_file in main.tf" \
    --expect-exit 0

# Step 3: Student validates configuration
student_exec "cd ~/terraform-troubleshoot-challenge && ([ -d .terraform ] || terraform init) && terraform validate" \
    --desc "Student runs terraform validate" \
    --expect-exit 0 \
    --expect-stdout "Success! The configuration is valid."

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Resource reference error resolved."
