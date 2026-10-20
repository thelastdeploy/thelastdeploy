# Recover a Broken Deployment

When rolling out updates to a Deployment, configurations can sometimes be invalid or specify broken image tags. In these cases, the rollout gets stuck.

---

## Triage stuck updates

To identify a stuck deployment:
1. **Rollout Status**: Check if the rollout is blocked:
   ```bash
   kubectl rollout status deployment/my-deployment
   ```
2. **Describe Deployment**: Check the replica count status and conditions:
   ```bash
   kubectl describe deployment my-deployment
   ```
   Under the `Conditions` section, look at `Progressing`. If its status is `False` with the reason `ProgressDeadlineExceeded`, the rollout is broken and has timed out.

---

## Recovery Workflow

To recover and fix a stuck deployment:
- **Set Correct Image**: Update the image dynamically to a valid name:
  ```bash
  kubectl set image deployment/my-deployment container-name=valid-image:tag
  ```
- **Undo / Rollback**: Roll back to the last known working revision:
  ```bash
  kubectl rollout undo deployment/my-deployment
  ```

---

## Lab Tasks

### Task 1: Fix Stuck Rollout
1. Start the lab in your terminal:
   ```bash
   tld start k8s-fix-broken-deployment
   ```
2. Inspect the stuck deployment `broken-deploy` and its pods to diagnose why the rollout failed:
   ```bash
   kubectl describe deployment broken-deploy
   kubectl get pods
   ```
3. Update the container image of deployment `broken-deploy` to a valid image (e.g. `nginx:1.16.1`):
   ```bash
   kubectl set image deployment/broken-deploy broken-deploy=nginx:1.16.1
   ```
4. Wait for the rollout to complete and verify that the replica is ready:
   ```bash
   kubectl rollout status deployment/broken-deploy
   kubectl get deployment broken-deploy
   ```
5. Verify the task:
   ```bash
   tld check
   ```
