#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Rename Resource using State Move
# Module: terraform-state
# Section: 06-state-commands
# Lab ID: tf-state-move-resource
# ==============================================================================
set -euo pipefail

LAB_ID="tf-state-move-resource"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Ensure seed setup is present
student_exec "cd ~/terraform-state-challenge && ([ -f terraform.tfstate ] || (echo 'resource \"local_file\" \"old_name\" { content = \"data\" \n filename = \"/tmp/mv.txt\" }' > main.tf && terraform init && terraform apply -auto-approve && echo 'resource \"local_file\" \"new_name\" { content = \"data\" \n filename = \"/tmp/mv.txt\" }' > main.tf))" \
    --desc "Student ensures seed state and configuration are ready" \
    --expect-exit 0

# Step 3: Student renames resource in state using terraform state mv
student_exec "cd ~/terraform-state-challenge && terraform state mv local_file.old_name local_file.new_name" \
    --desc "Student moves resource address in state" \
    --expect-exit 0 \
    --expect-stdout "Successfully moved 1 object(s)"

# Step 4: Student confirms state contains new_name
student_exec "cd ~/terraform-state-challenge && terraform state list" \
    --desc "Student verifies new_name exists in state list" \
    --expect-exit 0 \
    --expect-stdout "local_file.new_name"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: State resource renamed successfully using state mv."
