#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Diagnoses Routing Problem
# Lab: lnx-diagnose-routing-problem
# ==============================================================================

# Step 1: Inspect diagnosis notes and configuration
student_exec \
  --step-name "Inspect diag notes" \
  --cmd "cat ~/net-test/routing_problem/diag.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "10.0.0.254"

student_exec \
  --step-name "Inspect routes conf" \
  --cmd "cat ~/net-test/routing_problem/routes.conf" \
  --expect-exit-code 0

# Step 2: Fix gateway in routes.conf
student_exec \
  --step-name "Update gateway to 10.0.0.254" \
  --cmd "sed -i 's/192.168.99.99/10.0.0.254/' ~/net-test/routing_problem/routes.conf" \
  --expect-exit-code 0

# Step 3: Verify content of routes.conf
student_exec \
  --step-name "Verify routes.conf content" \
  --cmd "cat ~/net-test/routing_problem/routes.conf" \
  --expect-exit-code 0 \
  --expect-stdout-contains "10.0.0.254"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUCCESS: Routing problem diagnosed and resolved."
