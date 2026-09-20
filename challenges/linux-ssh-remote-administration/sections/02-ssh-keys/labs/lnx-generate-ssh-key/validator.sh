#!/bin/bash
set -euo pipefail

PRIV_KEY="$HOME/ssh-test/key_dir/id_ed25519"
PUB_KEY="$HOME/ssh-test/key_dir/id_ed25519.pub"

if [ ! -f "$PRIV_KEY" ]; then
    echo "FAIL: Private key $PRIV_KEY does not exist."
    exit 1
fi

if [ ! -f "$PUB_KEY" ]; then
    echo "FAIL: Public key $PUB_KEY does not exist."
    exit 1
fi

if ! grep -q "ssh-ed25519" "$PUB_KEY"; then
    echo "FAIL: $PUB_KEY does not appear to be an ED25519 public key."
    exit 1
fi

echo "PASS: SSH keypair generation verified."
exit 0
