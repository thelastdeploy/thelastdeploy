#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create an Explicit Dependency
# Module: terraform-resources
# Section: 04-resource-dependencies
# Lab ID: tf-explicit-dependency
# ==============================================================================
set -euo pipefail

LAB_ID="tf-explicit-dependency"

# Step 1: Student creates main.tf with explicit depends_on
student_exec "cat << 'EOF' > ~/terraform-resources-challenge/main.tf
resource \"local_file\" \"db\" {
  content  = \"database ready\"
  filename = \"/tmp/db.txt\"
}

resource \"local_file\" \"app\" {
  content    = \"application\"
  filename   = \"/tmp/app.txt\"
  depends_on = [local_file.db]
}
EOF" \
    --desc "Student writes explicit depends_on configuration" \
    --expect-exit 0

# Step 2: Student inspects main.tf
student_exec "cat ~/terraform-resources-challenge/main.tf" \
    --desc "Student inspects main.tf" \
    --expect-exit 0 \
    --expect-stdout "depends_on"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Explicit dependency verified."
