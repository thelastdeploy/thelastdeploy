# Pod Lifecycle

Pods follow a defined lifecycle, starting in the `Pending` phase, moving through `Running` if at least one primary container starts successfully, and then either terminating in `Succeeded` or `Failed` depending on exit status.

---

## Pod Phases

The `phase` of a Pod is a simple, high-level summary of where the Pod is in its execution:
- **Pending**: The Pod has been accepted by the Kubernetes cluster, but one or more of the containers has not been set up and made ready to run. This includes time a Pod spends waiting to be scheduled as well as downloading images over the network.
- **Running**: The Pod has been bound to a node, and all of the containers have been created. At least one container is currently running, or is in the process of starting or restarting.
- **Succeeded**: All containers in the Pod have terminated successfully (exited with code 0) and will not be restarted.
- **Failed**: All containers in the Pod have terminated, and at least one container has terminated in failure (exited with a non-zero code).
- **Unknown**: The state of the Pod cannot be obtained (typically due to network communication failure between the control plane and node kubelet).

---

## Init Containers

An **Init Container** is a specialized container that runs *before* the application containers in a Pod start. Init containers must run to completion (exit with status 0) before any app container can start.

If a Pod's init container fails, Kubernetes restarts the Pod repeatedly until the init container succeeds. While the init container is running, the Pod is in the `Pending` phase (specifically shown as `Init:0/1` or similar status).

---

## Container Restart Policies

The `restartPolicy` specifies how Kubernetes responds when a container exits:
- `Always` (default): Restarts the container whenever it terminates (useful for web servers, long-running services).
- `OnFailure`: Restarts the container only if it exits with a non-zero status (useful for batch jobs).
- `Never`: Never restarts the container.

---

## Lab Tasks

### Task 1: Observe Pod Restarts
1. Start the lab in your terminal:
   ```bash
   tld start k8s-pod-restarts
   ```
2. Monitor the restart count of `restart-pod` using `kubectl get pod`:
   ```bash
   kubectl get pod restart-pod -w
   ```
3. Once the restart count reaches at least 2, query the exact restart count and save it to `~/k8s-pods/restarts.txt`:
   ```bash
   mkdir -p ~/k8s-pods
   kubectl get pod restart-pod -o jsonpath='{.status.containerStatuses[0].restartCount}' > ~/k8s-pods/restarts.txt
   ```
4. Verify that `~/k8s-pods/restarts.txt` contains a valid integer (e.g. `2` or higher):
   ```bash
   cat ~/k8s-pods/restarts.txt
   ```
5. Check your solution:
   ```bash
   tld check
   ```

### Task 2: Inspect Pod Phases
1. Start the lab in your terminal:
   ```bash
   tld start k8s-watch-pod-lifecycle
   ```
2. Inspect the lifecycle phase of a Pod while its init containers are executing:
   ```bash
   kubectl get pod init-pod
   ```
3. Record the high-level pod lifecycle phase (`Pending`) into `~/k8s-pods/init-status.txt`:
   ```bash
   mkdir -p ~/k8s-pods
   echo "Pending" > ~/k8s-pods/init-status.txt
   ```
4. Confirm `~/k8s-pods/init-status.txt` contains `Pending`:
   ```bash
   cat ~/k8s-pods/init-status.txt
   ```
5. Check your solution:
   ```bash
   tld check
   ```
