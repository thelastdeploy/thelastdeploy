#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/net-sec/ssh_hardening.conf" ] && grep -q "SSH_AND_SUDO_ACCESS_HARDENED" "$HOME/net-sec/ssh_hardening.conf"; then
    echo "PASS: Manage Remote Administration verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Manage Remote Administration."
    exit 1
fi
