#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Import an Existing Resource into State
# Module: terraform-state
# Section: 05-importing-existing-resources
# Lab ID: tf-import-resource
# ==============================================================================
set -euo pipefail

LAB_ID="tf-import-resource"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Ensure seed setup is present
student_exec "echo 'existing file content' > /tmp/existing.txt && cd ~/terraform-state-challenge && ([ -d .terraform ] || terraform init)" \
    --desc "Student ensures pre-existing resource and terraform initialization" \
    --expect-exit 0

# Step 3: Student imports existing file resource into state
student_exec "cd ~/terraform-state-challenge && terraform import local_file.existing /tmp/existing.txt" \
    --desc "Student imports local_file.existing" \
    --expect-exit 0 \
    --expect-stdout "Import successful!"

# Step 4: Student verifies imported resource in state
student_exec "cd ~/terraform-state-challenge && terraform state list" \
    --desc "Student verifies resource in state list" \
    --expect-exit 0 \
    --expect-stdout "local_file.existing"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Resource imported into state successfully."
