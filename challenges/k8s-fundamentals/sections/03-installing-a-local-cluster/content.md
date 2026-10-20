# Installing a Local Cluster

To learn and develop applications on Kubernetes, you don't need a multi-node cloud cluster. Several tools allow you to spin up a fully-functional Kubernetes cluster on your local machine.

## Common Local Kubernetes Tools

1. **Minikube**: Spins up a single-node Kubernetes cluster inside a local virtual machine (VM) or container. Highly configurable and feature-rich.
2. **k3s / k3d**: A lightweight Kubernetes distribution packaged as a single binary, optimized for IoT and Edge computing. `k3d` runs `k3s` inside Docker.
3. **Kind (Kubernetes in Docker)**: A tool for running local Kubernetes clusters using Docker container "nodes". It was primarily designed for testing Kubernetes itself, but is widely used for local development due to its speed and simplicity.

---

## Working with Local Kubernetes Clusters

To communicate with any Kubernetes cluster—whether running locally via single-node engines (like k3s or minikube) or in the cloud—the primary tool used by DevOps engineers is **kubectl**.

### Kubectl Basics
`kubectl` is the official command-line interface for communicating with the Kubernetes API server. It reads cluster connection credentials from a configuration file called `kubeconfig` (located by default at `~/.kube/config`).

To inspect client version and connection details:
```bash
kubectl version --client
kubectl cluster-info
```

To list cluster nodes:
```bash
kubectl get nodes
```

---

## Lab Tasks

### Task 1: Install and Verify Kubectl
1. Start the lab in your terminal:
   ```bash
   tld start k8s-install-kind
   ```
2. Verify that the `kubectl` CLI binary is installed and accessible in your environment:
   ```bash
   kubectl version --client
   ```
3. Once verified, submit your solution:
   ```bash
   tld check
   ```

### Task 2: Verify Cluster Access
1. Start the lab in your terminal:
   ```bash
   tld start k8s-verify-cluster
   ```
2. Inspect the nodes in the local Kubernetes cluster:
   ```bash
   kubectl get nodes
   ```
3. Extract the control-plane node name and write it into `~/k8s-fundamentals/node-name.txt`:
   ```bash
   mkdir -p ~/k8s-fundamentals
   kubectl get nodes -o jsonpath='{.items[0].metadata.name}' > ~/k8s-fundamentals/node-name.txt
   ```
4. Verify that `~/k8s-fundamentals/node-name.txt` contains solely the control-plane node name:
   ```bash
   cat ~/k8s-fundamentals/node-name.txt
   ```
5. Check your solution:
   ```bash
   tld check
   ```
