## Container Inspection

To query low-level configuration, network settings, volume bindings, or runtime statuses of a container, Docker provides a powerful metadata querying utility called `docker inspect`.

---

## 1. Inspecting Metadata (`docker inspect`)

The `docker inspect` command outputs a detailed JSON array containing all configuration parameters of a container or image:

```bash
docker inspect my-container
```

Because the output is long, you can use the `--format` (or `-f`) flag which accepts Go templates to print only the specific details you need.

### Useful Format Examples
* **Get IP Address**:
  ```bash
  docker inspect --format '{{.NetworkSettings.IPAddress}}' my-container
  ```
* **Get Log Path**:
  ```bash
  docker inspect --format '{{.LogPath}}' my-container
  ```
* **Get Container State**:
  ```bash
  docker inspect --format '{{.State.Status}}' my-container
  ```

Alternatively, you can pipe the JSON output to utilities like `grep` or `jq` to locate fields.

---

## Lab Tasks

### Task 1: Find container IP address
1. Start the lab in your terminal:
   ```bash
   tld start dkr-find-container-config
   ```
2. A container named `config-target` is running in the background. Locate its **IP Address** within the default network.
3. Save only the IP address (e.g., `172.17.0.2`) to a file named `container_ip.txt` inside your `~/docker-test/` directory.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Locate container log path
1. Start the lab in your terminal:
   ```bash
   tld start dkr-inspect-container
   ```
2. A background container named `inspect-target` is running. Your goal is to inspect it and locate the host filesystem path of its JSON log file (`LogPath`).
3. Save the absolute file path (e.g., `/var/lib/docker/containers/...`) to a file named `log_path.txt` inside your `~/docker-test/` directory.
4. Verify the task:
   ```bash
   tld check
   ```
