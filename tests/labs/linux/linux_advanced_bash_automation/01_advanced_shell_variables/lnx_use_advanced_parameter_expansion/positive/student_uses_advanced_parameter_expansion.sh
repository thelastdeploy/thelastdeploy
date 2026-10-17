#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Uses Advanced Parameter Expansion
# Lab: lnx-use-advanced-parameter-expansion
# ==============================================================================

# Step 1: Ensure param-test directory exists
student_exec \
  --step-name "Ensure param-test directory exists" \
  --cmd "mkdir -p ~/param-test" \
  --expect-exit-code 0

# Step 2: Write parameter expansion results to processed.txt
student_exec \
  --step-name "Generate processed.txt using parameter expansion" \
  --cmd "FILEPATH='/var/log/app/service.log'; MODE='dev_environment'; echo \"\${FILEPATH%.log}.bak\" > ~/param-test/processed.txt; echo \"\${FILEPATH##*/}\" >> ~/param-test/processed.txt; echo \"\${MODE^^}\" >> ~/param-test/processed.txt" \
  --expect-exit-code 0

# Step 3: Verify content of processed.txt
student_exec \
  --step-name "Verify processed.txt content" \
  --cmd "cat ~/param-test/processed.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "service.log"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Parameter expansion output verified successfully."
