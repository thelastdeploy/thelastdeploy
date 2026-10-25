#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Recover from Corrupt or Missing State
# Module: terraform-troubleshooting
# Section: 06-state-errors
# Lab ID: tf-recover-state
# ==============================================================================
set -euo pipefail

LAB_ID="tf-recover-state"

# Step 1: Ensure terraform is available in test container
student_exec "which terraform || (curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/tf.zip && unzip -qo /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip)" \
    --desc "Student ensures terraform is available" \
    --expect-exit 0

# Step 2: Ensure seed setup is present
student_exec "echo 'data' > /tmp/state_rec.txt && cd ~/terraform-troubleshoot-challenge && ([ -d .terraform ] || terraform init)" \
    --desc "Student ensures workspace is initialized" \
    --expect-exit 0

# Step 3: Student recovers state tracking by running terraform apply
student_exec "cd ~/terraform-troubleshoot-challenge && terraform apply -auto-approve" \
    --desc "Student applies configuration to recover state" \
    --expect-exit 0 \
    --expect-stdout "Apply complete!"

# Step 4: Student confirms state contains local_file.app
student_exec "cd ~/terraform-troubleshoot-challenge && terraform state list" \
    --desc "Student verifies state list" \
    --expect-exit 0 \
    --expect-stdout "local_file.app"

# Step 5: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: State recovered and verified."
