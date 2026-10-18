#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Persists Application Data
# Lab: dkr-persist-application-data
# ==============================================================================

# Step 1: Start initial container mounting named volume
student_exec \
  --step-name "Start db-container with volume db-storage-vol" \
  --cmd "docker run -d --name db-container -v db-storage-vol:/usr/share/nginx/html nginx:alpine" \
  --expect-exit-code 0

# Step 2: Write persistent file into volume via initial container
student_exec \
  --step-name "Write index.html into volume" \
  --cmd "docker exec db-container sh -c 'echo \"Database persistent content\" > /usr/share/nginx/html/index.html'" \
  --expect-exit-code 0

# Step 3: Remove initial container
student_exec \
  --step-name "Remove initial container db-container" \
  --cmd "docker rm -f db-container" \
  --expect-exit-code 0

# Step 4: Start new container mounting the same volume
student_exec \
  --step-name "Start db-container-new with same volume" \
  --cmd "docker run -d --name db-container-new -v db-storage-vol:/usr/share/nginx/html nginx:alpine" \
  --expect-exit-code 0

# Step 5: Verify persistent content in new container
student_exec \
  --step-name "Verify index.html content in new container" \
  --cmd "docker exec db-container-new cat /usr/share/nginx/html/index.html" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Database persistent content"

# Step 6: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully verified data persistence across container replacements using named volumes."
