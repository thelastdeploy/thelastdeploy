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
  docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my-container
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

### Task 1: Find container IP address (`dkr-find-container-config`)
1. Start the lab session:
   ```bash
   tld start dkr-find-container-config
   ```
2. A container named `config-target` is running in the background. Locate its IP address using `docker inspect` with formatting:
   ```bash
   mkdir -p "$HOME/docker-test"
   docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' config-target > "$HOME/docker-test/container_ip.txt"
   ```
3. Verify file contents:
   ```bash
   cat "$HOME/docker-test/container_ip.txt"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Locate container log path (`dkr-inspect-container`)
1. Start the lab session:
   ```bash
   tld start dkr-inspect-container
   ```
2. A background container named `inspect-target` is running. Inspect it and locate the host filesystem path of its JSON log file (`LogPath`):
   ```bash
   mkdir -p "$HOME/docker-test"
   docker inspect --format '{{.LogPath}}' inspect-target > "$HOME/docker-test/log_path.txt"
   ```
3. Verify file contents:
   ```bash
   cat "$HOME/docker-test/log_path.txt"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
