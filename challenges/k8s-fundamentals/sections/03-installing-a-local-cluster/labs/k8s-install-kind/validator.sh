#!/bin/bash
# validator.sh — k8s-fundamentals / 03-installing-a-local-cluster / k8s-install-kind
set -euo pipefail

# 1. Check if kubectl is available
if ! command -v kubectl &>/dev/null; then
  echo "FAIL: kubectl command not found. Please install kubectl first."
  exit 1
fi

# 2. Check if kubectl client is functioning
if ! kubectl version --client &>/dev/null; then
  echo "FAIL: kubectl client is not functioning properly."
  exit 1
fi

echo "PASS: Kubectl is successfully installed and verified!"
exit 0
