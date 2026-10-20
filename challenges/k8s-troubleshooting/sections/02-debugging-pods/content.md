# Debugging Pods

When a Pod isn't running correctly, it usually stays in a failed state like `ImagePullBackOff`, `CrashLoopBackOff`, or `Pending`. Understanding these states is crucial to diagnosing pod-level problems.

---

## 1. ImagePullBackOff

This state indicates that Kubernetes is unable to retrieve the container image specified in the Pod definition.
- **Common causes**: Typo in the image name/tag, or referencing a private registry without configuring imagePullSecrets.
- **Diagnose**: Run `kubectl describe pod <pod-name>` and look at events for errors like `pull access denied` or `manifest not found`.

---

## 2. CrashLoopBackOff

This status shows that the container successfully scheduled and started, but then crashed immediately. Kubernetes restarts it, but because it keeps crashing, a back-off delay is applied before subsequent restarts.
- **Common causes**: Application bugs, unhandled exceptions, missing environment variables, or incorrect run command arguments.
- **Diagnose**: View application standard logs:
  ```bash
  # Read stdout/stderr logs of the crashed container
  kubectl logs <pod-name>

  # Read logs of the *previous* crashed instance of the pod
  kubectl logs <pod-name> --previous
  ```

---

## 3. Pending Pods

A Pod remains in `Pending` state when it cannot be scheduled on any node in the cluster.
- **Common causes**: Insufficient resources (CPU or Memory requests exceed node capacity), unsatisfiable nodeSelectors or taints.
- **Diagnose**: Run `kubectl describe pod <pod-name>` and inspect the warning events under the scheduler.

---

## Lab Tasks

### Task 1: Debug CrashLoopBackOff
1. Start the lab in your terminal:
   ```bash
   tld start k8s-debug-crashloopbackoff
   ```
2. Navigate to your working directory:
   ```bash
   cd ~/k8s-troubleshooting
   ```
3. Inspect the logs of `crashing-app` to retrieve the fatal error code:
   ```bash
   kubectl logs crashing-app
   ```
4. Write the error code (`FATAL_ERROR_CODE_9876`) into `~/k8s-troubleshooting/crash-code.txt`:
   ```bash
   echo "FATAL_ERROR_CODE_9876" > ~/k8s-troubleshooting/crash-code.txt
   ```
5. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Debug ImagePullBackOff
1. Start the lab in your terminal:
   ```bash
   tld start k8s-debug-imagepullbackoff
   ```
2. Inspect the failing pod `pull-failed-pod` to observe the image pull failure:
   ```bash
   kubectl describe pod pull-failed-pod
   ```
3. Update the container image to `nginx`:
   ```bash
   kubectl set image pod/pull-failed-pod pull-failed-pod=nginx
   ```
4. Wait for the pod to reach the `Running` phase:
   ```bash
   kubectl wait --for=condition=Ready pod/pull-failed-pod --timeout=60s
   ```
5. Verify the task:
   ```bash
   tld check
   ```

### Task 3: Debug Pending Pod
1. Start the lab in your terminal:
   ```bash
   tld start k8s-debug-pending-pod
   ```
2. Navigate to your working directory:
   ```bash
   cd ~/k8s-troubleshooting
   ```
3. Inspect `pending-pod` to view the scheduler warning event regarding insufficient CPU:
   ```bash
   kubectl describe pod pending-pod
   ```
4. Delete the pod, update `pending-pod.yaml` with a lower CPU request (e.g. `100m`), and re-apply:
   ```bash
   kubectl delete pod pending-pod
   sed -i 's/cpu: "100"/cpu: "100m"/' ~/k8s-troubleshooting/pending-pod.yaml
   kubectl apply -f ~/k8s-troubleshooting/pending-pod.yaml
   ```
5. Wait for the pod to be scheduled and reach the `Running` phase:
   ```bash
   kubectl wait --for=condition=Ready pod/pending-pod --timeout=60s
   ```
6. Verify the task:
   ```bash
   tld check
   ```
