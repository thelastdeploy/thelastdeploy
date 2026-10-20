# Recover a Stateful Application

Storage issues are one of the most common causes of Pod failures in stateful configurations. When a Pod references a PersistentVolumeClaim that doesn't exist, cannot be bound, or has access conflicts, it gets stuck in `ContainerCreating`, `Pending`, or `CrashLoopBackOff` state.

---

## Triage Storage Errors

To diagnose storage and mount errors:
1. **Get Pod Status**: See if the pod is stuck:
   ```bash
   kubectl get pods
   ```
2. **Describe Pod**: Look for storage warning events:
   ```bash
   kubectl describe pod db-pod
   ```
   Look for warnings like:
   - `FailedMount`: Volume mount failed (e.g. storage driver error, lock conflicts).
   - `FailedScheduling`: Could not match nodes (e.g. PV is located in zone-a, but pod was scheduled to zone-b).
   - `volume... not found`: The claimName referenced in Pod volumes does not exist in the namespace.

---

## Resolving Missing Claim Failures

If a Pod references a non-existent claim name, you must create a PersistentVolumeClaim with the exact matching metadata name in that namespace. Once the claim is created, the control plane binds it to a PersistentVolume, and the node's kubelet immediately mounts it, allowing the container to start.

---

## Lab Tasks

### Task 1: Fix Pod Storage Mount
1. Start the lab in your terminal:
   ```bash
   tld start k8s-fix-storage-configuration
   ```
2. Navigate to your working directory:
   ```bash
   cd ~/k8s-storage
   ```
3. Inspect `db-pod` and its events to identify why the pod cannot start:
   ```bash
   kubectl describe pod db-pod
   ```
   Notice that the pod is waiting for a PersistentVolumeClaim named `non-existent-claim` to be bound.
4. Create the missing PersistentVolumeClaim named `non-existent-claim` requesting `1Gi` storage with `ReadWriteOnce` access mode:
   ```bash
   cat <<EOF | kubectl apply -f -
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: non-existent-claim
   spec:
     accessModes:
       - ReadWriteOnce
     resources:
       requests:
         storage: 1Gi
   EOF
   ```
5. Wait for `db-pod` to mount the storage and reach the `Running` phase:
   ```bash
   kubectl wait --for=condition=Ready pod/db-pod --timeout=60s
   ```
6. Verify the task:
   ```bash
   tld check
   ```
