#!/usr/bin/env bash
set -euo pipefail

REGISTRY="${REGISTRY:-ghcr.io/thelastdeploy}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Building base image: linux-base..."
docker build -t "${REGISTRY}/linux-base:latest" "${SCRIPT_DIR}/linux-base"

CHILD_IMAGES=("nginx-base" "docker-dind" "git-base" "terraform-base" "k8s-base")

for img in "${CHILD_IMAGES[@]}"; do
    echo "==> Building dependent image: ${img}..."
    docker build \
        --build-arg BASE_IMAGE="${REGISTRY}/linux-base:latest" \
        -t "${REGISTRY}/${img}:latest" \
        "${SCRIPT_DIR}/${img}"
done

echo ""
echo "✓ All images built successfully:"
echo "  - ${REGISTRY}/linux-base:latest"
for img in "${CHILD_IMAGES[@]}"; do
    echo "  - ${REGISTRY}/${img}:latest"
done
