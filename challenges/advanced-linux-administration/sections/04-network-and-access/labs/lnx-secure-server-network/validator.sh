#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/net-sec/firewall_hardening.log" ] && grep -q "STATEFUL_FIREWALL_RULES_CONFIGURED" "$HOME/net-sec/firewall_hardening.log"; then
    echo "PASS: Secure Server Network verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Secure Server Network."
    exit 1
fi
