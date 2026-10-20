# Recover a Broken Application

Real-world production incidents rarely have a single cause. A broken application often combines several simultaneous issues: a deployment using a bad image, a missing ConfigMap it depends on, or a misconfigured Secret mount.

---

## Multi-Layer Triage Workflow

When an application is completely down, work systematically from the top down:

### Step 1 — Identify Failing Pods
```bash
kubectl get pods
```
Look for any pod not in `Running` state.

### Step 2 — Read Events
```bash
kubectl describe pod <pod-name>
```
Events section reveals whether the failure is due to image pulls, volume mounts, scheduling, or liveness probes.

### Step 3 — Fix in Dependency Order

If a deployment depends on a ConfigMap that doesn't exist, create the ConfigMap **first**, then fix the deployment image. The correct fix order prevents the cluster from cycling through partial failures.

### Step 4 — Verify Recovery
```bash
kubectl get pods
kubectl rollout status deployment/<deployment-name>
```
Confirm all pods transition to `Running` state and the rollout completes successfully.

---

## Lab Tasks

### Task 1: Recover Production Application
1. Start the lab in your terminal:
   ```bash
   tld start k8s-recover-production-application
   ```
2. Inspect the failing deployment `frontend-deploy` and its pod events:
   ```bash
   kubectl get pods
   kubectl describe deployment frontend-deploy
   ```
3. Resolve the missing dependency by creating the required ConfigMap `frontend-config`:
   ```bash
   kubectl create configmap frontend-config --from-literal=APP_ENV=production
   ```
4. Update the container image from the broken tag to a valid image (such as `nginx:alpine` or `nginx`):
   ```bash
   kubectl set image deployment/frontend-deploy frontend=nginx:alpine
   ```
5. Monitor the rollout status until the pod is ready and running:
   ```bash
   kubectl rollout status deployment/frontend-deploy
   ```
6. Verify the task:
   ```bash
   tld check
   ```
