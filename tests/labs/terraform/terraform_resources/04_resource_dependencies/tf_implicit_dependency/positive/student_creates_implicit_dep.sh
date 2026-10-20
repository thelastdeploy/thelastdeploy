#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Create an Implicit Dependency
# Module: terraform-resources
# Section: 04-resource-dependencies
# Lab ID: tf-implicit-dependency
# ==============================================================================
set -euo pipefail

LAB_ID="tf-implicit-dependency"

# Step 1: Student creates main.tf with implicit dependency reference
student_exec "cat << 'EOF' > ~/terraform-resources-challenge/main.tf
resource \"random_id\" \"server\" {
  byte_length = 8
}

resource \"local_file\" \"config\" {
  content  = \"Server ID: \${random_id.server.hex}\"
  filename = \"/tmp/server_config.txt\"
}
EOF" \
    --desc "Student writes implicit dependency reference in main.tf" \
    --expect-exit 0

# Step 2: Student inspects main.tf
student_exec "cat ~/terraform-resources-challenge/main.tf" \
    --desc "Student inspects main.tf" \
    --expect-exit 0 \
    --expect-stdout "random_id.server.hex"

# Step 3: Student runs tld check to validate lab completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Implicit dependency verified."
