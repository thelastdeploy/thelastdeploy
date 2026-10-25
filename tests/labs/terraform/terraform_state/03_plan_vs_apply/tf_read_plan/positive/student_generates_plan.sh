#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Generate and Read Execution Plan
# Module: terraform-state
# Section: 03-plan-vs-apply
# Lab ID: tf-read-plan
# ==============================================================================
set -euo pipefail

LAB_ID="tf-read-plan"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Ensure workspace is initialized
student_exec "cd ~/terraform-state-challenge && ([ -d .terraform ] || terraform init)" \
    --desc "Student ensures workspace is initialized" \
    --expect-exit 0

# Step 3: Student generates and saves execution plan
student_exec "cd ~/terraform-state-challenge && terraform plan -out=tfplan" \
    --desc "Student generates execution plan output to tfplan" \
    --expect-exit 0 \
    --expect-stdout "Saved the plan to: tfplan"

# Step 4: Student confirms tfplan exists
student_exec "test -f ~/terraform-state-challenge/tfplan" \
    --desc "Student confirms tfplan file exists" \
    --expect-exit 0

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Execution plan generated and saved successfully."
