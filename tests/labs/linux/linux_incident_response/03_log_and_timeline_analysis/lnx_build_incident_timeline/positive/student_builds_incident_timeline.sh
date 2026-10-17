#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Builds Chronological Incident Timeline
# Lab: lnx-build-incident-timeline
# ==============================================================================

# Step 1: Ensure timeline-test directory exists
student_exec \
  --step-name "Ensure timeline-test directory exists" \
  --cmd "mkdir -p ~/timeline-test" \
  --expect-exit-code 0

# Step 2: Inspect auth log and journal events
student_exec \
  --step-name "Inspect auth log and journal events" \
  --cmd "grep -E 'Accepted|Failed|Invalid' /var/log/auth.log 2>/dev/null || true && journalctl -n 20 --no-pager 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write incident timeline marker
student_exec \
  --step-name "Write incident timeline marker" \
  --cmd "echo 'INCIDENT_TIMELINE_BUILT' > ~/timeline-test/incident_timeline.txt" \
  --expect-exit-code 0

# Step 4: Verify incident_timeline.txt content
student_exec \
  --step-name "Verify incident_timeline.txt content" \
  --cmd "cat ~/timeline-test/incident_timeline.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "INCIDENT_TIMELINE_BUILT"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Chronological incident timeline construction verified."
