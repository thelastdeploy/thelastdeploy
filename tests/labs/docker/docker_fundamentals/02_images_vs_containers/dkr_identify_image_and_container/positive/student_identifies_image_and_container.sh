#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Identifies Image and Container
# Lab: dkr-identify-image-and-container
# ==============================================================================

# Step 1: Ensure docker-test directory exists
student_exec \
  --step-name "Ensure docker-test directory exists" \
  --cmd "mkdir -p ~/docker-test" \
  --expect-exit-code 0

# Step 2: Save hello-world image ID
student_exec \
  --step-name "Save hello-world image ID" \
  --cmd "docker images hello-world:latest --format '{{.ID}}' > ~/docker-test/image_id.txt" \
  --expect-exit-code 0

# Step 3: Save stopped container ID
student_exec \
  --step-name "Save container ID" \
  --cmd "docker ps -a --filter name=ident-target-container --format '{{.ID}}' > ~/docker-test/container_id.txt" \
  --expect-exit-code 0

# Step 4: Verify generated ID files
student_exec \
  --step-name "Verify generated ID files" \
  --cmd "cat ~/docker-test/image_id.txt && cat ~/docker-test/container_id.txt" \
  --expect-exit-code 0

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully identified the correct image and container IDs."
