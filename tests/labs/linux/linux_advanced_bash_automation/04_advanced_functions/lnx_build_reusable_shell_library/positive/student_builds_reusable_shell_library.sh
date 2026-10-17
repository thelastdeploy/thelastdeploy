#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Builds a Reusable Shell Library
# Lab: lnx-build-reusable-shell-library
# ==============================================================================

# Step 1: Ensure lib-test directory exists
student_exec \
  --step-name "Ensure lib-test directory exists" \
  --cmd "mkdir -p ~/lib-test" \
  --expect-exit-code 0

# Step 2: Create utils.sh shell library
student_exec \
  --step-name "Create utils.sh library" \
  --cmd "cat << 'EOF' > ~/lib-test/utils.sh
#!/bin/bash

log_info() {
    echo \"[INFO] \$1\"
}

log_error() {
    echo \"[ERROR] \$1\" >&2
}

is_file_empty() {
    local file=\"\${1:-}\"
    if [ ! -f \"\$file\" ] || [ ! -s \"\$file\" ]; then
        return 0
    else
        return 1
    fi
}
EOF
chmod +x ~/lib-test/utils.sh" \
  --expect-exit-code 0

# Step 3: Create test_runner.sh to exercise the library
student_exec \
  --step-name "Create test_runner.sh script" \
  --cmd "cat << 'EOF' > ~/lib-test/test_runner.sh
#!/bin/bash
source \"\$HOME/lib-test/utils.sh\"

log_info \"Running test suite\"
EOF
chmod +x ~/lib-test/test_runner.sh && ~/lib-test/test_runner.sh" \
  --expect-exit-code 0 \
  --expect-stdout-contains "[INFO] Running test suite"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Reusable shell library functions verified."
