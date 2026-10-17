#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Filters Journal Events by Priority and Format
# Lab: lnx-filter-journal-events
# ==============================================================================

# Step 1: Ensure log-test directory exists
student_exec \
  --step-name "Ensure log-test directory exists" \
  --cmd "mkdir -p ~/log-test" \
  --expect-exit-code 0

# Step 2: Create priority_cmd.sh script with correct journalctl options
student_exec \
  --step-name "Create priority_cmd.sh script" \
  --cmd "cat << 'EOF' > ~/log-test/priority_cmd.sh
#!/bin/bash
journalctl -p err -o json-pretty
EOF
chmod +x ~/log-test/priority_cmd.sh" \
  --expect-exit-code 0

# Step 3: Verify script content and executable permission
student_exec \
  --step-name "Verify priority_cmd.sh exists and is executable" \
  --cmd "test -x ~/log-test/priority_cmd.sh && cat ~/log-test/priority_cmd.sh" \
  --expect-exit-code 0 \
  --expect-stdout-contains "journalctl -p err -o json-pretty"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Journal priority and JSON formatting filter verified."
