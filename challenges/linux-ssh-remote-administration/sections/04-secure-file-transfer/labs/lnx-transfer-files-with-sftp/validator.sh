#!/bin/bash
set -euo pipefail

BATCH_FILE="$HOME/ssh-test/sftp_batch.txt"

if [ ! -f "$BATCH_FILE" ]; then
    echo "FAIL: $BATCH_FILE does not exist."
    exit 1
fi

CONTENT=$(cat "$BATCH_FILE")

if ! echo "$CONTENT" | grep -Eq "put local_config\.json /etc/app/config\.json"; then
    echo "FAIL: $BATCH_FILE missing 'put local_config.json /etc/app/config.json' command."
    exit 1
fi

if ! echo "$CONTENT" | grep -Eq "(bye|exit)"; then
    echo "FAIL: $BATCH_FILE missing session termination command ('bye' or 'exit')."
    exit 1
fi

echo "PASS: SFTP batch file transfer script verified."
exit 0
