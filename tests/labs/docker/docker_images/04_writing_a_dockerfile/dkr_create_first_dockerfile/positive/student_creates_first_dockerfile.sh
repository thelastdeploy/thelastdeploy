#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates First Dockerfile
# Lab: dkr-create-first-dockerfile
# ==============================================================================

# Step 1: Ensure directory exists
student_exec \
  --step-name "Ensure directory exists" \
  --cmd "mkdir -p ~/docker-build/first-dockerfile" \
  --expect-exit-code 0

# Step 2: Write Dockerfile
student_exec \
  --step-name "Write Dockerfile" \
  --cmd "cat << 'EOF' > ~/docker-build/first-dockerfile/Dockerfile
FROM alpine:3.18
ENV APP_COLOR=blue
CMD [\"echo\", \"Hello DevLab\"]
EOF" \
  --expect-exit-code 0

# Step 3: Verify Dockerfile content
student_exec \
  --step-name "Verify Dockerfile content" \
  --cmd "cat ~/docker-build/first-dockerfile/Dockerfile" \
  --expect-exit-code 0 \
  --expect-stdout-contains "FROM alpine:3.18"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully created and verified first Dockerfile."
