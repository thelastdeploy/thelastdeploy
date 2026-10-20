#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create Your First Resource Block
# Module: terraform-hcl
# Section: 03-writing-your-first-resource
# Lab ID: tf-first-resource
# ==============================================================================
set -euo pipefail

LAB_ID="tf-first-resource"

# Step 1: Student creates main.tf with local_file resource block named welcome
student_exec "cat << 'EOF' > ~/terraform-hcl-challenge/main.tf
resource \"local_file\" \"welcome\" {
  content  = \"Welcome to The Last Deploy!\"
  filename = \"/tmp/welcome.txt\"
}
EOF" \
    --desc "Student writes local_file welcome resource block to main.tf" \
    --expect-exit 0

# Step 2: Student inspects main.tf
student_exec "cat ~/terraform-hcl-challenge/main.tf" \
    --desc "Student inspects main.tf" \
    --expect-exit 0 \
    --expect-stdout "resource \"local_file\" \"welcome\""

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: First resource block created successfully."
