#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Use Basic Expressions
# Module: terraform-hcl
# Section: 05-expressions
# Lab ID: tf-basic-expressions
# ==============================================================================
set -euo pipefail

LAB_ID="tf-basic-expressions"

# Step 1: Student updates main.tf with string interpolation expression
student_exec "cat << 'EOF' > ~/terraform-hcl-challenge/main.tf
resource \"local_file\" \"expr\" {
  content  = \"Running in directory: \${path.module}\"
  filename = \"/tmp/expr.txt\"
}
EOF" \
    --desc "Student writes string interpolation expression in main.tf" \
    --expect-exit 0

# Step 2: Student inspects main.tf
student_exec "cat ~/terraform-hcl-challenge/main.tf" \
    --desc "Student inspects main.tf" \
    --expect-exit 0 \
    --expect-stdout "\${path.module}"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: String interpolation validated successfully."
