#!/bin/bash
# validator.sh — k8s-fundamentals / 03-installing-a-local-cluster / k8s-verify-cluster
set -euo pipefail

FILE="$HOME/k8s-fundamentals/node-name.txt"

if [ ! -f "$FILE" ]; then
  echo "FAIL: $FILE does not exist. Did you write the node name to it?"
  exit 1
fi

CONTENT=$(tr -d '[:space:]' < "$FILE")

if [ -z "$CONTENT" ]; then
  echo "FAIL: $FILE is empty. Please save the control-plane node name into it."
  exit 1
fi

ACTUAL_NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")

if [ -z "$ACTUAL_NODE" ]; then
  echo "FAIL: Could not query cluster nodes. Is the cluster running?"
  exit 1
fi

if [ "$CONTENT" != "$ACTUAL_NODE" ]; then
  echo "FAIL: Incorrect node name in $FILE. Expected '$ACTUAL_NODE', got '$CONTENT'"
  exit 1
fi

echo "PASS: Successfully verified cluster access and retrieved the control-plane node name!"
exit 0
