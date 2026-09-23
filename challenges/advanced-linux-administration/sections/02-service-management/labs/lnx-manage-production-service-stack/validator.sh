#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/service-stack/production_stack.status" ] && grep -q "PRODUCTION_SERVICE_STACK_OPERATIONAL" "$HOME/service-stack/production_stack.status"; then
    echo "PASS: Manage Production Service Stack verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Manage Production Service Stack."
    exit 1
fi
