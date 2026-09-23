#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/service-stack/service_dependencies.log" ] && grep -q "SYSTEMD_SERVICE_DEPENDENCIES_CONFIGURED" "$HOME/service-stack/service_dependencies.log"; then
    echo "PASS: Design Service Dependencies verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Design Service Dependencies."
    exit 1
fi
