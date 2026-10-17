#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Expands Production Storage Capstone
# Lab: lnx-expand-production-storage
# ==============================================================================

# Step 1: Ensure lvm-capstone directory exists
student_exec \
  --step-name "Ensure lvm-capstone directory exists" \
  --cmd "mkdir -p ~/lvm-capstone" \
  --expect-exit-code 0

# Step 2: Write storage expansion automation script
student_exec \
  --step-name "Create expand_app.sh automation script" \
  --cmd "cat << 'EOF' > ~/lvm-capstone/expand_app.sh
#!/usr/bin/env bash
lvextend -L +5G -r /dev/vg_app/lv_data
EOF
chmod +x ~/lvm-capstone/expand_app.sh" \
  --expect-exit-code 0

# Step 3: Write summary log line
student_exec \
  --step-name "Write expansion summary log" \
  --cmd "echo 'PRODUCTION_EXPANSION_COMPLETE' > ~/lvm-capstone/expansion.log" \
  --expect-exit-code 0

# Step 4: Verify content of expansion.log
student_exec \
  --step-name "Verify expansion.log content" \
  --cmd "cat ~/lvm-capstone/expansion.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PRODUCTION_EXPANSION_COMPLETE"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Production volume expansion capstone verified."
