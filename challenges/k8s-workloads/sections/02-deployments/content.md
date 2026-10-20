# Deployments

A Kubernetes Deployment provides declarative updates for Pods and ReplicaSets.

---

## Deployment Manifest Structure

Here is a standard YAML manifest for an Nginx Deployment:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

### Key Manifest Fields

1. **apiVersion**: Specifies the API version (for Deployments, always `apps/v1`).
2. **kind**: The resource type (`Deployment`).
3. **spec.replicas**: Specifies the number of identical pods to run (in this case, 3).
4. **spec.selector**: Tells the deployment controller which Pods to manage. The labels specified under `matchLabels` **must** match the labels defined in the pod template (`spec.template.metadata.labels`).
5. **spec.template**: The pod template spec. This defines the pods that the deployment creates.

---

## Managing Deployments

### Create / Apply
```bash
kubectl apply -f deployment.yaml
```

### Listing Deployments
```bash
kubectl get deployments
# Or abbreviated:
kubectl get deploy
```

### Describing Deployments
```bash
kubectl describe deployment nginx-deployment
```
Describing a deployment displays replicas status, conditions (e.g. `Available`, `Progressing`), and controller events.

---

## Lab Tasks

### Task 1: Create a Deployment
1. Start the lab in your terminal:
   ```bash
   tld start k8s-create-deployment
   ```
2. Create a Deployment manifest named `nginx-deployment.yaml` with the following configuration:
   - Deployment name: `nginx-deployment`
   - Replicas: `3`
   - Image: `nginx:1.14.2`
   - Matching labels: `app: nginx`
3. Apply the manifest to your cluster:
   ```bash
   kubectl apply -f nginx-deployment.yaml
   ```
4. Confirm that all 3 replicas are ready:
   ```bash
   kubectl get deployment nginx-deployment
   ```
5. Check your solution:
   ```bash
   tld check
   ```

### Task 2: List Deployments
1. Start the lab in your terminal:
   ```bash
   tld start k8s-list-deployments
   ```
2. Count the total number of deployments across all namespaces:
   ```bash
   kubectl get deployments -A --no-headers | wc -l
   ```
3. Save solely the numeric count to `~/k8s-workloads/deployments-count.txt`:
   ```bash
   mkdir -p ~/k8s-workloads
   kubectl get deployments -A --no-headers | wc -l | tr -d ' ' > ~/k8s-workloads/deployments-count.txt
   ```
4. Confirm that `~/k8s-workloads/deployments-count.txt` contains the integer count:
   ```bash
   cat ~/k8s-workloads/deployments-count.txt
   ```
5. Check your solution:
   ```bash
   tld check
   ```
