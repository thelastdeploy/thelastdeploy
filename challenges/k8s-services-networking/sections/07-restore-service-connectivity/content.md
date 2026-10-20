# Troubleshooting Service Connectivity

When a service is unreachable in Kubernetes, the issue typically resides in one of three areas: selector mismatches, port mismatches, or pod startup failures.

---

## 1. Verify Selector Matches Pod Labels

If the Service selector does not match the Pod labels, the Service will not route traffic because no endpoints will be created.

**How to verify:**
```bash
kubectl get endpoints <service-name>
```

If the `ENDPOINTS` column is `<none>` or empty, verify the selector using:
```bash
kubectl describe service <service-name>
```

And compare it with the actual labels on the Pod:
```bash
kubectl get pods --show-labels
```

---

## 2. Check Port and TargetPort Alignment

- **`port`**: The port clients use to access the service.
- **`targetPort`**: The port that the container inside the Pod listens on. If this is misconfigured (e.g. your app container listens on `8080` but `targetPort` is set to `80`), connections will fail.

**How to verify:**
Inspect the Pod definition or deployment manifest to confirm which port the container is actually exposing:
```bash
kubectl get pod <pod-name> -o yaml | grep containerPort
```

---

## 3. Verify Pod Health

A Service will only route traffic to Pods that are in the **`Ready`** state. If the Pod has crashed, is in `CrashLoopBackOff`, or has failed its readiness probe, the IP of the Pod is removed from the service endpoints.

**How to verify:**
```bash
kubectl get pods
```
Check if the `READY` column shows `0/1` or similar. If so, investigate pod conditions or readiness probes using `kubectl describe pod`.

---

## Lab Tasks

### Task 1: Debug Service Connectivity
1. Start the lab in your terminal:
   ```bash
   tld start k8s-debug-service-connectivity
   ```
2. Navigate to your working directory:
   ```bash
   cd ~/k8s-services-networking
   ```
3. Inspect `api-service` and compare its selector and targetPort with `api-pod`:
   ```bash
   kubectl describe service api-service
   kubectl get pod api-pod --show-labels
   ```
   Notice that the selector is set to `app=api-backend` (instead of `app=api-server`) and `targetPort` is set to `8080` (instead of `80`).
4. Fix the Service by applying a corrected manifest `api-service.yaml` with selector `app: api-server` and `targetPort: 80`:
   ```bash
   cat <<EOF > ~/k8s-services-networking/api-service.yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: api-service
   spec:
     selector:
       app: api-server
     ports:
     - port: 80
       targetPort: 80
   EOF
   kubectl apply -f ~/k8s-services-networking/api-service.yaml
   ```
5. Confirm that the Service now has active endpoints targeting `api-pod`:
   ```bash
   kubectl get endpoints api-service
   ```
6. Verify the task:
   ```bash
   tld check
   ```
