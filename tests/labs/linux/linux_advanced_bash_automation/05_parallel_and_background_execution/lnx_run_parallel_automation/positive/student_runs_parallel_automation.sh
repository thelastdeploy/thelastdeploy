#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Runs Parallel Automation Tasks
# Lab: lnx-run-parallel-automation
# ==============================================================================

# Step 1: Ensure parallel-test data and results directories exist
student_exec \
  --step-name "Ensure directories exist" \
  --cmd "mkdir -p ~/parallel-test/data ~/parallel-test/results" \
  --expect-exit-code 0

# Step 2: Seed data files
student_exec \
  --step-name "Seed 5 data files" \
  --cmd "for i in {1..5}; do echo \"sample data \$i\" > ~/parallel-test/data/f\$i.txt; done" \
  --expect-exit-code 0

# Step 3: Create batch_processor.sh script
student_exec \
  --step-name "Create batch_processor.sh script" \
  --cmd "cat << 'EOF' > ~/parallel-test/batch_processor.sh
#!/bin/bash
set -euo pipefail

for file in ~/parallel-test/data/*.txt; do
    filename=\$(basename \"\$file\")
    tr '[:lower:]' '[:upper:]' < \"\$file\" > ~/parallel-test/results/\"\$filename\" &
done

wait
EOF
chmod +x ~/parallel-test/batch_processor.sh" \
  --expect-exit-code 0

# Step 4: Execute batch_processor.sh
student_exec \
  --step-name "Execute batch_processor.sh" \
  --cmd "~/parallel-test/batch_processor.sh" \
  --expect-exit-code 0

# Step 5: Verify results
student_exec \
  --step-name "Verify f1.txt result content" \
  --cmd "cat ~/parallel-test/results/f1.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SAMPLE DATA 1"

# Step 6: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Parallel batch processing verified."
