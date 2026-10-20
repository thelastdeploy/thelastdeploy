# Kubectl Basics

`kubectl` is the Kubernetes command-line tool. It allows you to run commands against Kubernetes clusters, allowing you to deploy applications, inspect and manage cluster resources, and view logs.

## Kubectl Syntax

The common syntax of `kubectl` commands is:
```bash
kubectl [command] [TYPE] [NAME] [flags]
```
- **command**: Specifies the operation you want to perform (e.g. `create`, `get`, `describe`, `delete`).
- **TYPE**: Specifies the resource type (e.g. `pods`, `services`, `nodes`). Case-insensitive, singular, plural, or abbreviated forms are accepted (e.g. `pod`, `pods`, `po`).
- **NAME**: Specifies the name of the resource. Case-sensitive. If omitted, details for all resources of the specified TYPE are returned.
- **flags**: Specifies optional flags (e.g. `-o json` to change output format, `-n` to specify namespace).

---

## Essential Commands

### 1. Interrogating the Cluster
```bash
# Get cluster status and API endpoint details
kubectl cluster-info

# List all nodes in the cluster
kubectl get nodes
```

### 2. Getting Resources
```bash
# List all pods in the default namespace
kubectl get pods

# List pods with more details (like IP and node name)
kubectl get pods -o wide

# Get details of a specific service
kubectl get svc kubernetes
```

### 3. Inspecting Resource Details
```bash
# Describe a specific pod to see events and configuration
kubectl describe pod nginx-pod
```

### 4. Creating Resources (Imperative)
```bash
# Spin up an nginx pod directly
kubectl run my-nginx --image=nginx
```

---

## Lab Tasks

### Task 1: Get Cluster Information
1. Start the lab in your terminal:
   ```bash
   tld start k8s-cluster-information
   ```
2. Retrieve the ClusterIP of the default `kubernetes` service:
   ```bash
   kubectl get svc kubernetes
   ```
3. Extract the ClusterIP address and write it to `~/k8s-fundamentals/kubernetes-cluster-ip.txt`:
   ```bash
   mkdir -p ~/k8s-fundamentals
   kubectl get svc kubernetes -o jsonpath='{.spec.clusterIP}' > ~/k8s-fundamentals/kubernetes-cluster-ip.txt
   ```
4. Verify that `~/k8s-fundamentals/kubernetes-cluster-ip.txt` contains solely the IP address (e.g. `10.96.0.1`):
   ```bash
   cat ~/k8s-fundamentals/kubernetes-cluster-ip.txt
   ```
5. Check your solution:
   ```bash
   tld check
   ```

### Task 2: Describe a Resource
1. Start the lab in your terminal:
   ```bash
   tld start k8s-describe-resource
   ```
2. Inspect the labels assigned to the `web-server` pod:
   ```bash
   kubectl get pod web-server --show-labels
   ```
3. Extract the value of the `tier` label and save solely that value into `~/k8s-fundamentals/web-tier-label.txt`:
   ```bash
   mkdir -p ~/k8s-fundamentals
   kubectl get pod web-server -o jsonpath='{.metadata.labels.tier}' > ~/k8s-fundamentals/web-tier-label.txt
   ```
4. Confirm that `~/k8s-fundamentals/web-tier-label.txt` contains `web`:
   ```bash
   cat ~/k8s-fundamentals/web-tier-label.txt
   ```
5. Check your solution:
   ```bash
   tld check
   ```

### Task 3: List Cluster Resources
1. Start the lab in your terminal:
   ```bash
   tld start k8s-list-resources
   ```
2. List the names of all pods in the current namespace:
   ```bash
   kubectl get pods -o custom-columns=":metadata.name" --no-headers
   ```
3. Save the pod names, sorted alphabetically one per line, into `~/k8s-fundamentals/pods-list.txt`:
   ```bash
   mkdir -p ~/k8s-fundamentals
   kubectl get pods -o custom-columns=":metadata.name" --no-headers | sort > ~/k8s-fundamentals/pods-list.txt
   ```
4. Confirm `~/k8s-fundamentals/pods-list.txt` contains the sorted list:
   ```bash
   cat ~/k8s-fundamentals/pods-list.txt
   ```
5. Check your solution:
   ```bash
   tld check
   ```
