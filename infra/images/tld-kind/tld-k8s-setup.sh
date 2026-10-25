#!/usr/bin/env bash
set -e

# Wait for k3s kubeconfig to be generated
for i in $(seq 1 60); do
    if [ -s /etc/rancher/k3s/k3s.yaml ]; then
        break
    fi
    sleep 0.5
done

if [ ! -s /etc/rancher/k3s/k3s.yaml ]; then
    echo "warn: /etc/rancher/k3s/k3s.yaml not found yet" >&2
    exit 0
fi

# Insert all kind-tld-* lab contexts into k3s.yaml
python3 - << 'PYEOF'
import sys

LAB_IDS = [
    "k8s-install-kind", "k8s-verify-cluster", "k8s-cluster-information",
    "k8s-describe-resource", "k8s-list-resources", "k8s-create-namespace",
    "k8s-switch-namespace", "k8s-explore-cluster", "k8s-cluster-investigation",
    "k8s-create-first-pod", "k8s-delete-pod", "k8s-inspect-pod",
    "k8s-view-pod-logs", "k8s-exec-into-pod", "k8s-sidecar-pod",
    "k8s-pod-restarts", "k8s-watch-pod-lifecycle", "k8s-debug-failed-pod",
    "k8s-create-deployment", "k8s-list-deployments", "k8s-scale-deployment",
    "k8s-self-healing-demo", "k8s-add-labels", "k8s-query-by-label",
    "k8s-selector-match", "k8s-check-rollout", "k8s-update-image",
    "k8s-rollback-deployment", "k8s-fix-broken-deployment",
    "k8s-create-clusterip-service", "k8s-access-service", "k8s-create-nodeport",
    "k8s-access-nodeport", "k8s-service-dns", "k8s-install-ingress",
    "k8s-create-ingress", "k8s-restrict-traffic", "k8s-debug-service-connectivity",
    "k8s-create-configmap", "k8s-use-configmap", "k8s-create-secret",
    "k8s-use-secret", "k8s-emptydir-volume", "k8s-shared-volume",
    "k8s-create-pvc", "k8s-mount-persistent-volume", "k8s-fix-storage-configuration",
    "k8s-investigate-resources", "k8s-read-events", "k8s-debug-pending-pod",
    "k8s-debug-crashloopbackoff", "k8s-debug-imagepullbackoff", "k8s-debug-network-path",
    "k8s-fix-selector-mismatch", "k8s-debug-rollout", "k8s-recover-failed-update",
    "k8s-recover-production-application"
]

path = "/etc/rancher/k3s/k3s.yaml"
try:
    with open(path, "r") as f:
        content = f.read()

    marker = "contexts:\n- context:\n    cluster: default\n    user: default\n  name: default\n"
    if marker in content:
        extra_contexts = "".join(
            f"- context:\n    cluster: default\n    user: default\n  name: kind-tld-{id}\n"
            for id in LAB_IDS
            if f"name: kind-tld-{id}" not in content
        )
        content = content.replace(marker, marker + extra_contexts, 1)
        with open(path, "w") as f:
            f.write(content)
except Exception as e:
    sys.stderr.write(f"warn: failed to inject contexts: {e}\n")
PYEOF

mkdir -p /root/.kube
cp -f /etc/rancher/k3s/k3s.yaml /root/.kube/config
chmod 644 /etc/rancher/k3s/k3s.yaml /root/.kube/config

grep -q "KUBECONFIG" /etc/environment 2>/dev/null || echo "KUBECONFIG=/root/.kube/config" >> /etc/environment
grep -q "KUBECONFIG" /root/.bashrc 2>/dev/null || echo "export KUBECONFIG=/root/.kube/config" >> /root/.bashrc

# Wait for k3s API server and default service account to be available
for i in $(seq 1 60); do
    if /usr/local/bin/k3s kubectl get serviceaccount default &>/dev/null; then
        break
    fi
    sleep 0.5
done

# Copy kubeconfig for non-root student user if present
if [ -d /home/ubuntu ]; then
    mkdir -p /home/ubuntu/.kube
    cp -f /root/.kube/config /home/ubuntu/.kube/config
    chown -R ubuntu:ubuntu /home/ubuntu/.kube 2>/dev/null || true
    chmod 644 /home/ubuntu/.kube/config
fi

# Signal readiness to runner and test harness
mkdir -p /run/tld
touch /run/tld/k8s-ready /run/tld-k8s-ready
