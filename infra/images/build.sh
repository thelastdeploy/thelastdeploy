#!/usr/bin/env bash
set -euo pipefail

REGISTRY="${REGISTRY:-ghcr.io/thelastdeploy}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Building base image: tld-ubuntu..."
docker build -t "${REGISTRY}/tld-ubuntu:latest" "${SCRIPT_DIR}/tld-ubuntu"

CHILD_IMAGES=("tld-dind" "tld-kind")

for img in "${CHILD_IMAGES[@]}"; do
    echo "==> Building dependent image: ${img}..."
    docker build \
        --build-arg BASE_IMAGE="${REGISTRY}/tld-ubuntu:latest" \
        -t "${REGISTRY}/${img}:latest" \
        "${SCRIPT_DIR}/${img}"
done

echo ""
echo "✓ All images built successfully:"
echo "  - ${REGISTRY}/tld-ubuntu:latest"
for img in "${CHILD_IMAGES[@]}"; do
    echo "  - ${REGISTRY}/${img}:latest"
done
