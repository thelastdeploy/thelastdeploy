#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Broken Connectivity Capstone
# Lab: lnx-recover-broken-connectivity
# ==============================================================================

# Step 1: Update LISTEN_IP in server.env
student_exec \
  --step-name "Update listen ip to 0.0.0.0" \
  --cmd "sed -i 's/LISTEN_IP=\"127.0.0.1\"/LISTEN_IP=\"0.0.0.0\"/' ~/net-challenge/config/server.env" \
  --expect-exit-code 0

# Step 2: Add nameserver 8.8.8.8 to resolv.conf
student_exec \
  --step-name "Add nameserver 8.8.8.8" \
  --cmd "echo 'nameserver 8.8.8.8' >> ~/net-challenge/config/resolv.conf" \
  --expect-exit-code 0

# Step 3: Set status to CONNECTIVITY: RESTORED
student_exec \
  --step-name "Update status to restored" \
  --cmd "echo 'CONNECTIVITY: RESTORED' > ~/net-challenge/status/app.status" \
  --expect-exit-code 0

# Step 4: Verify content of app.status
student_exec \
  --step-name "Verify app.status content" \
  --cmd "cat ~/net-challenge/status/app.status" \
  --expect-exit-code 0 \
  --expect-stdout-contains "CONNECTIVITY: RESTORED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SUCCESS: Network connectivity restored and app status verified."
