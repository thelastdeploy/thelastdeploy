#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Works with Arrays in Bash
# Lab: lnx-work-with-arrays
# ==============================================================================

# Step 1: Ensure array-test directory exists
student_exec \
  --step-name "Ensure array-test directory exists" \
  --cmd "mkdir -p ~/array-test" \
  --expect-exit-code 0

# Step 2: Build indexed array, sort, and write servers.txt
student_exec \
  --step-name "Create sorted servers.txt" \
  --cmd "declare -a SERVERS=('web-01' 'db-01' 'app-01'); printf '%s\n' \"\${SERVERS[@]}\" | sort > ~/array-test/servers.txt" \
  --expect-exit-code 0

# Step 3: Build associative array and write config.txt
student_exec \
  --step-name "Create config.txt from associative array" \
  --cmd "declare -A CONFIG=([port]='8080' [env]='production'); for key in \"\${!CONFIG[@]}\"; do echo \"\$key=\${CONFIG[\$key]}\"; done > ~/array-test/config.txt" \
  --expect-exit-code 0

# Step 4: Verify files exist and have content
student_exec \
  --step-name "Verify array outputs" \
  --cmd "cat ~/array-test/servers.txt && cat ~/array-test/config.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "port=8080"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Array manipulation verified successfully."
