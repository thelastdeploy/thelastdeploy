#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Detect Infrastructure State Drift
# Module: terraform-state
# Section: 04-state-drift
# Lab ID: tf-detect-drift
# ==============================================================================
set -euo pipefail

LAB_ID="tf-detect-drift"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Ensure seed setup is present
student_exec "cd ~/terraform-state-challenge && ([ -f terraform.tfstate ] || (terraform init && terraform apply -auto-approve)) && echo 'out_of_band_change' > /tmp/drift.txt" \
    --desc "Student ensures out-of-band drift is present" \
    --expect-exit 0

# Step 3: Student runs terraform plan to inspect drift
student_exec "cd ~/terraform-state-challenge && terraform plan" \
    --desc "Student runs terraform plan to detect drift" \
    --expect-exit 0 \
    --expect-stdout "Plan: 1 to add"

# Step 4: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: State drift detection verified."
