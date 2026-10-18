## Container Lifecycle

A Docker container passes through several states during its lifetime: Created, Running, Stopped, and Removed. Learning how to navigate and transition between these states is vital to managing resources efficiently.

---

## 1. Container States and Transition Commands

```
   `docker create`        `docker start`         `docker stop`
 [ Image ] -------> [ Stopped ] -------> [ Running ] -------> [ Stopped ]
                       |                                         |
                       | `docker rm`                             | `docker rm -f`
                       v                                         v
                  [ Deleted ]                               [ Deleted ]
```

* **docker stop <container>**: Sends a `SIGTERM` signal to the container's main process, allowing it to shut down gracefully. If it doesn't shut down within a timeout period (default 10s), it sends `SIGKILL`.
* **docker start <container>**: Starts an existing stopped container, preserving its file changes and configuration.
* **docker rm <container>**: Deletes a stopped container. To delete a running container, you must either stop it first or force-delete it using `docker rm -f`.

---

## 2. Listing Containers (`docker ps`)

* To see only currently **running** containers:
  ```bash
  docker ps
  ```
* To see **all** containers (running, exited, stopped):
  ```bash
  docker ps -a
  ```

---

## Lab Tasks

### Task 1: Remove a container (`dkr-remove-container`)
1. Start the lab session:
   ```bash
   tld start dkr-remove-container
   ```
2. Your system has a stopped container named `old-trash-container`. Permanently remove it:
   ```bash
   docker rm old-trash-container
   ```
3. Verify the container has been deleted:
   ```bash
   docker ps -a --filter name=old-trash-container
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Start a stopped container (`dkr-start-stopped-container`)
1. Start the lab session:
   ```bash
   tld start dkr-start-stopped-container
   ```
2. Start the existing stopped container named `stopped-sleeper`:
   ```bash
   docker start stopped-sleeper
   ```
3. Verify the container is running:
   ```bash
   docker ps --filter name=stopped-sleeper
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 3: Stop a running container (`dkr-stop-running-container`)
1. Start the lab session:
   ```bash
   tld start dkr-stop-running-container
   ```
2. Stop the running container named `runaway-container` safely without removing it:
   ```bash
   docker stop runaway-container
   ```
3. Verify the container is stopped:
   ```bash
   docker ps -a --filter name=runaway-container
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
