# Debugging Services

Services provide a stable entrypoint (IP and DNS) to access a set of dynamic Pods. When service routing fails, clients get connection timeouts or errors.

---

## 1. Selector Mismatches

Services route traffic to Pods by matching labels. A tiny typo in the service selector will result in zero traffic being sent to your pods.

### Triage:
Check the active backend targets of a Service using `kubectl get endpoints`:
```bash
# View endpoints matching the service
kubectl get endpoints <service-name>
```
If the output shows `<none>` under `ENDPOINTS`, it means the Service selector does not match the labels of any running pods in that namespace.

Compare the Service selector labels with the target Pod labels:
```bash
# View service selector
kubectl get svc <service-name> -o jsonpath='{.spec.selector}'

# View pod labels
kubectl get pods --show-labels
```

---

## 2. Port Mismatches

- **`port`**: The port exposed on the Service's cluster IP.
- **`targetPort`**: The port that the container application inside the pod is actually listening on.

If the service `targetPort` is configured incorrectly (e.g. Service targetPort is `80`, but the pod application listens on `8080`), connection attempts through the Service cluster IP will fail despite endpoints showing as active.

---

## Lab Tasks

### Task 1: Debug Service Endpoints
1. Start the lab in your terminal:
   ```bash
   tld start k8s-debug-network-path
   ```
2. Navigate to your working directory:
   ```bash
   cd ~/k8s-troubleshooting
   ```
3. Query the pod IP address of `web-pod` and save it to `~/k8s-troubleshooting/endpoints.txt`:
   ```bash
   kubectl get pod web-pod -o jsonpath='{.status.podIP}' > ~/k8s-troubleshooting/endpoints.txt
   ```
4. Verify the file contents:
   ```bash
   cat ~/k8s-troubleshooting/endpoints.txt
   ```
5. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Fix Service Selector
1. Start the lab in your terminal:
   ```bash
   tld start k8s-fix-selector-mismatch
   ```
2. Navigate to your working directory:
   ```bash
   cd ~/k8s-troubleshooting
   ```
3. Update the selector of `web-service` to match the pod label `app=web`:
   ```bash
   kubectl set selector service web-service app=web
   ```
4. Confirm that `web-service` now has active endpoints:
   ```bash
   kubectl get endpoints web-service
   ```
5. Verify the task:
   ```bash
   tld check
   ```
