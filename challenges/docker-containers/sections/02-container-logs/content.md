## Container Logs

When applications run in detached mode inside containers, their standard output (stdout) and standard error (stderr) streams are captured by Docker. To understand what is happening inside your container, you must inspect these logs.

---

## 1. Viewing Container Logs (`docker logs`)

The `docker logs` command fetches the logs of a container using its name or ID:

```bash
docker logs my-app
```

### Useful Flags
* **Follow logs (`-f` / `--follow`)**: Streams live logs to your console (similar to `tail -f`):
  ```bash
  docker logs -f my-app
  ```
* **Limit lines (`--tail`)**: Shows only the last N lines:
  ```bash
  docker logs --tail 20 my-app
  ```
* **Show timestamps (`-t` / `--timestamps`)**: Prepends timestamps to log lines:
  ```bash
  docker logs -t my-app
  ```

---

## Lab Tasks

### Task 1: Find container error (`dkr-find-container-error`)
1. Start the lab session:
   ```bash
   tld start dkr-find-container-error
   ```
2. A background container named `buggy-app` is currently running and logging outputs. Inspect its logs:
   ```bash
   docker logs buggy-app
   ```
3. Extract the critical error text following `CRITICAL_ERROR:` and save it to `~/docker-test/error_msg.txt`:
   ```bash
   mkdir -p "$HOME/docker-test"
   docker logs buggy-app 2>&1 | grep "CRITICAL_ERROR:" | awk -F': ' '{print $2}' > "$HOME/docker-test/error_msg.txt"
   ```
4. Verify file contents:
   ```bash
   cat "$HOME/docker-test/error_msg.txt"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Read container logs (`dkr-read-container-logs`)
1. Start the lab session:
   ```bash
   tld start dkr-read-container-logs
   ```
2. Inspect logs of the stopped container named `logger-app`:
   ```bash
   docker logs logger-app
   ```
3. Extract the complete line starting with `SECRET_FLAG=` and save it into `~/docker-test/container_flag.txt`:
   ```bash
   mkdir -p "$HOME/docker-test"
   docker logs logger-app 2>&1 | grep "SECRET_FLAG=" > "$HOME/docker-test/container_flag.txt"
   ```
4. Verify file contents:
   ```bash
   cat "$HOME/docker-test/container_flag.txt"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
