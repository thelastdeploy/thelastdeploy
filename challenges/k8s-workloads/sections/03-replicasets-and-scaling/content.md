# ReplicaSets and Scaling

A Deployment does not manage Pods directly. Instead, it delegates pod management to a **ReplicaSet**.

---

## What is a ReplicaSet?

A **ReplicaSet**'s purpose is to maintain a stable set of replica Pods running at any given time.
- When you create a Deployment, the Deployment Controller automatically creates a ReplicaSet in the background.
- The ReplicaSet uses labels to identify and track its pods.

---

## Horizontal Scaling

Scaling an application running on Kubernetes is extremely fast because you only need to update the desired replica count. The ReplicaSet handles the creation or deletion of container instances.

### 1. Scaling Imperatively
You can scale a deployment directly from the CLI:
```bash
kubectl scale deployment nginx-deployment --replicas=5
```

### 2. Scaling Declaratively
Update the `spec.replicas` field inside your deployment manifest and run `kubectl apply -f deployment.yaml`.

---

## Self-Healing

One of Kubernetes' primary features is **Self-Healing**:
- If a pod crashes due to application errors, the local node `kubelet` restarts the container inside the pod.
- If a pod is deleted (e.g. server hardware crashes, or manual deletion), the ReplicaSet controller notices that the *current count* of running pods does not match the *desired replica count*.
- The ReplicaSet scheduler immediately schedules a new replacement pod to run on any available node in the cluster.

---

## Lab Tasks

### Task 1: Scale a Deployment
1. Start the lab in your terminal:
   ```bash
   tld start k8s-scale-deployment
   ```
2. Check the current replicas of `web-deploy`:
   ```bash
   kubectl get deployment web-deploy
   ```
3. Scale the deployment up from 2 to 5 replicas:
   ```bash
   kubectl scale deployment web-deploy --replicas=5
   ```
4. Confirm that all 5 replicas are running and ready:
   ```bash
   kubectl get deployment web-deploy
   ```
5. Check your solution:
   ```bash
   tld check
   ```

### Task 2: Self-Healing Deployment
1. Start the lab in your terminal:
   ```bash
   tld start k8s-self-healing-demo
   ```
2. Inspect the currently running pod of deployment `app-deploy`:
   ```bash
   cat ~/k8s-workloads/initial-pod.txt
   kubectl get pods -l app=app-deploy
   ```
3. Delete the running pod to trigger self-healing:
   ```bash
   kubectl delete pod -l app=app-deploy
   ```
4. Wait for the ReplicaSet to spawn a replacement pod, then write the new pod's name to `~/k8s-workloads/new-pod.txt`:
   ```bash
   mkdir -p ~/k8s-workloads
   kubectl get pods -l app=app-deploy -o jsonpath='{.items[0].metadata.name}' > ~/k8s-workloads/new-pod.txt
   ```
5. Confirm `~/k8s-workloads/new-pod.txt` contains the new pod name:
   ```bash
   cat ~/k8s-workloads/new-pod.txt
   ```
6. Check your solution:
   ```bash
   tld check
   ```
