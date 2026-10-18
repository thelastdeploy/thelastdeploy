#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Builds Custom Nginx Site
# Lab: dkr-build-custom-nginx-site
# ==============================================================================

# Step 1: Ensure directory exists and has index.html
student_exec \
  --step-name "Ensure directory and html file exist" \
  --cmd "mkdir -p ~/docker-build/nginx-custom && echo '<h1>Hello from Nginx</h1>' > ~/docker-build/nginx-custom/index.html" \
  --expect-exit-code 0

# Step 2: Write Dockerfile
student_exec \
  --step-name "Write Dockerfile" \
  --cmd "cat << 'EOF' > ~/docker-build/nginx-custom/Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EOF" \
  --expect-exit-code 0

# Step 3: Build Docker image tagged as my-nginx-web:latest
student_exec \
  --step-name "Build Docker image" \
  --cmd "docker build -t my-nginx-web:latest ~/docker-build/nginx-custom" \
  --expect-exit-code 0

# Step 4: Verify image exists locally
student_exec \
  --step-name "Verify image exists" \
  --cmd "docker image inspect my-nginx-web:latest" \
  --expect-exit-code 0

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully built custom Nginx web server image."
