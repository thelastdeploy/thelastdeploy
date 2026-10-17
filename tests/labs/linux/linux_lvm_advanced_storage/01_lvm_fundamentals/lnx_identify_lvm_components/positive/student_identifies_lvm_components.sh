#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Identifies LVM Components and Layer Hierarchy
# Lab: lnx-identify-lvm-components
# ==============================================================================

# Step 1: Ensure lvm-test directory exists
student_exec \
  --step-name "Ensure lvm-test directory exists" \
  --cmd "mkdir -p ~/lvm-test" \
  --expect-exit-code 0

# Step 2: Write LVM hierarchy to lvm_hierarchy.txt
student_exec \
  --step-name "Write LVM hierarchy" \
  --cmd "cat << 'EOF' > ~/lvm-test/lvm_hierarchy.txt
1. Physical Volume (PV)
2. Volume Group (VG)
3. Logical Volume (LV)
4. Filesystem
5. Mount Point
EOF" \
  --expect-exit-code 0

# Step 3: Verify content of lvm_hierarchy.txt
student_exec \
  --step-name "Verify lvm_hierarchy.txt content" \
  --cmd "cat ~/lvm-test/lvm_hierarchy.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "1. Physical Volume"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: LVM components and hierarchy verified."
