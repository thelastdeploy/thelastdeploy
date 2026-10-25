#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: List Resources in State
# Module: terraform-state
# Section: 02-inspecting-state
# Lab ID: tf-list-state
# ==============================================================================
set -euo pipefail

LAB_ID="tf-list-state"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Ensure seed resources are initialized and applied
student_exec "cd ~/terraform-state-challenge && ([ -f terraform.tfstate ] || (terraform init && terraform apply -auto-approve))" \
    --desc "Student ensures state file is present" \
    --expect-exit 0

# Step 3: Student lists managed resources in state
student_exec "cd ~/terraform-state-challenge && terraform state list" \
    --desc "Student runs terraform state list" \
    --expect-exit 0 \
    --expect-stdout "local_file.f1"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: State listing verified."
