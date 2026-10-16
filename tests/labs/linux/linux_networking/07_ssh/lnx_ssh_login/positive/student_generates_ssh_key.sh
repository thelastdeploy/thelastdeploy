#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Generate an SSH key pair
# Module: linux-networking
# Section: 07-ssh
# Lab ID: lnx-ssh-login
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-ssh-login"

# Step 1: Student generates an Ed25519 key pair
student_exec "mkdir -p ~/.ssh && chmod 700 ~/.ssh && ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519" \
    --desc "Student creates SSH keypair" \
    --expect-exit 0

# Step 2: Student inspects the generated public key
student_exec "cat ~/.ssh/id_ed25519.pub" \
    --desc "Student inspects generated public key format" \
    --expect-exit 0 \
    --expect-stdout "ssh-ed25519"

# Step 3: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: SSH key pair successfully generated."
