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

### Task 1: Find container error
1. Start the lab in your terminal:
   ```bash
   tld start dkr-find-container-error
   ```
2. A background container named `buggy-app` is currently running and logging outputs. Find the log line starting with `CRITICAL_ERROR:`.
3. Save the error message text *after* the colon (e.g. `db_connection_failed` if the log is `CRITICAL_ERROR: db_connection_failed`) to a file named `error_msg.txt` inside your `~/docker-test/` directory.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Read container logs
1. Start the lab in your terminal:
   ```bash
   tld start dkr-read-container-logs
   ```
2. There is a stopped container named `logger-app` on your system. Read its logs to find the line containing the secret flag (`SECRET_FLAG=...`).
3. Save that complete line (e.g., `SECRET_FLAG=abc...`) to a file named `container_flag.txt` inside your `~/docker-test/` directory.
4. Verify the task:
   ```bash
   tld check
   ```
