#!/bin/bash
set -euo pipefail

AUTH_KEYS="$HOME/ssh-test/server_home/.ssh/authorized_keys"

if [ ! -f "$AUTH_KEYS" ]; then
    echo "FAIL: $AUTH_KEYS does not exist."
    exit 1
fi

if ! grep -q "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDummyPublicKeyForTesting" "$AUTH_KEYS"; then
    echo "FAIL: $AUTH_KEYS does not contain the public key content."
    exit 1
fi

PERMS=$(stat -c "%a" "$AUTH_KEYS")
if [ "$PERMS" != "600" ]; then
    echo "FAIL: $AUTH_KEYS permission must be 600, found $PERMS."
    exit 1
fi

echo "PASS: Key authentication configuration and permissions verified."
exit 0
