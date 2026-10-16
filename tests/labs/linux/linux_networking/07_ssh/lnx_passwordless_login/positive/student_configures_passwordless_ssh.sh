#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Setup passwordless login to localhost
# Module: linux-networking
# Section: 07-ssh
# Lab ID: lnx-passwordless-login
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-passwordless-login"

# Step 1: Student creates SSH directory and generates keypair
student_exec "mkdir -p ~/.ssh && chmod 700 ~/.ssh && ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519" \
    --desc "Student generates Ed25519 keypair" \
    --expect-exit 0

# Step 2: Student authorizes public key
student_exec "cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys" \
    --desc "Student adds public key to authorized_keys" \
    --expect-exit 0

# Step 3: Student ensures SSH service is running
student_exec "systemctl start ssh.socket >/dev/null 2>&1 || systemctl start ssh >/dev/null 2>&1 || service ssh start >/dev/null 2>&1 || /usr/sbin/sshd >/dev/null 2>&1 || true" \
    --desc "Student ensures SSH daemon is running" \
    --expect-exit 0

# Step 4: Student tests passwordless connection to localhost
student_exec "ssh -o BatchMode=yes -o StrictHostKeyChecking=no localhost echo 'SSH_SUCCESS'" \
    --desc "Student executes test command over SSH to localhost" \
    --expect-exit 0 \
    --expect-stdout "SSH_SUCCESS"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Passwordless SSH login to localhost configured successfully."
