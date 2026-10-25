#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Reconcile Drifting Infrastructure
# Module: terraform-state
# Section: 08-recover-from-state-drift
# Lab ID: tf-fix-state
# ==============================================================================
set -euo pipefail

LAB_ID="tf-fix-state"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Ensure seed setup is present
student_exec "cd ~/terraform-state-challenge && ([ -f terraform.tfstate ] || (terraform init && terraform apply -auto-approve)) && rm -f /tmp/recovery.txt" \
    --desc "Student ensures drift condition is present" \
    --expect-exit 0

# Step 3: Student reconciles drift by applying configuration
student_exec "cd ~/terraform-state-challenge && terraform apply -auto-approve" \
    --desc "Student reconciles drifted state using terraform apply" \
    --expect-exit 0 \
    --expect-stdout "Apply complete!"

# Step 4: Student confirms restored file content
student_exec "cat /tmp/recovery.txt" \
    --desc "Student verifies restored file content" \
    --expect-exit 0 \
    --expect-stdout "expected_state"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: State drift recovered and infrastructure restored successfully."
