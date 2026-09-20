#!/bin/bash
set -euo pipefail

SSH_DIR="$HOME/ssh-challenge/remote_server/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"
CLIENT_CONF="$HOME/ssh-challenge/client_config"
STATUS_FILE="$HOME/ssh-challenge/recovery_status.txt"

# 1. Directory permissions
if [ ! -d "$SSH_DIR" ]; then
    echo "FAIL: $SSH_DIR directory does not exist."
    exit 1
fi

DIR_PERMS=$(stat -c "%a" "$SSH_DIR")
if [ "$DIR_PERMS" != "700" ]; then
    echo "FAIL: $SSH_DIR permission must be 700, found $DIR_PERMS."
    exit 1
fi

# 2. Authorized keys content & permissions
if [ ! -f "$AUTH_KEYS" ]; then
    echo "FAIL: $AUTH_KEYS file does not exist."
    exit 1
fi

FILE_PERMS=$(stat -c "%a" "$AUTH_KEYS")
if [ "$FILE_PERMS" != "600" ]; then
    echo "FAIL: $AUTH_KEYS permission must be 600, found $FILE_PERMS."
    exit 1
fi

if ! grep -q "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICapstoneRecoveryPublicKey" "$AUTH_KEYS"; then
    echo "FAIL: $AUTH_KEYS missing the client public key."
    exit 1
fi

# 3. Client config file & permissions
if [ ! -f "$CLIENT_CONF" ]; then
    echo "FAIL: Client config file $CLIENT_CONF does not exist."
    exit 1
fi

CONF_PERMS=$(stat -c "%a" "$CLIENT_CONF")
if [ "$CONF_PERMS" != "600" ]; then
    echo "FAIL: $CLIENT_CONF permission must be 600, found $CONF_PERMS."
    exit 1
fi

if ! grep -qi "Host recovery-target" "$CLIENT_CONF"; then
    echo "FAIL: $CLIENT_CONF missing 'Host recovery-target' alias."
    exit 1
fi

# 4. Status file verification
if [ ! -f "$STATUS_FILE" ]; then
    echo "FAIL: Recovery status file $STATUS_FILE does not exist."
    exit 1
fi

if ! grep -q "SSH_RECOVERY_COMPLETE" "$STATUS_FILE"; then
    echo "FAIL: $STATUS_FILE does not contain 'SSH_RECOVERY_COMPLETE'."
    exit 1
fi

echo "PASS: SSH administration capstone challenge fully verified."
exit 0
