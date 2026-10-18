#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Fixes Container Startup Failure
# Lab: dkr-fix-startup-failure
# ==============================================================================

# Step 1: Ensure initial test state with occupying container
student_exec \
  --step-name "Ensure initial occupying container is running" \
  --cmd "docker rm -f host-port-occupier nginx-service || true; docker run -d --name host-port-occupier -p 8084:80 nginx:alpine" \
  --expect-exit-code 0

# Step 2: Remove the blocking container
student_exec \
  --step-name "Remove blocking container" \
  --cmd "docker rm -f host-port-occupier" \
  --expect-exit-code 0

# Step 3: Run the target container on the freed port
student_exec \
  --step-name "Start nginx-service container on port 8084" \
  --cmd "docker run -d --name nginx-service -p 8084:80 nginx:alpine" \
  --expect-exit-code 0

# Step 4: Verify that nginx-service is running
student_exec \
  --step-name "Verify container is running" \
  --cmd "docker ps --filter 'name=nginx-service' --format '{{.Names}}'" \
  --expect-exit-code 0 \
  --expect-stdout-contains "nginx-service"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Resolved port collision and started nginx-service successfully."
