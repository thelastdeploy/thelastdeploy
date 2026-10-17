#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Establishes Incident Context and Initial Observation
# Lab: lnx-establish-incident-context
# ==============================================================================

# Step 1: Ensure ir-test directory exists
student_exec \
  --step-name "Ensure ir-test directory exists" \
  --cmd "mkdir -p ~/ir-test" \
  --expect-exit-code 0

# Step 2: Perform non-destructive incident observation
student_exec \
  --step-name "Perform non-destructive incident observation" \
  --cmd "w && who && uptime" \
  --expect-exit-code 0

# Step 3: Write observation summary marker
student_exec \
  --step-name "Write observation summary marker" \
  --cmd "echo 'INCIDENT_CONTEXT_ESTABLISHED' > ~/ir-test/context.txt" \
  --expect-exit-code 0

# Step 4: Verify context.txt content
student_exec \
  --step-name "Verify context.txt content" \
  --cmd "cat ~/ir-test/context.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "INCIDENT_CONTEXT_ESTABLISHED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Incident context and initial observation verified."
