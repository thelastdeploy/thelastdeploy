## Reading Docker Errors

When containerized applications fail, they do not have a visual console. Understanding how to query and parse container runtime details is the key to Docker troubleshooting.

---

### 1. Retrieving Logs (`docker logs`)

The primary source of truth is stdout and stderr streams of the container:
```bash
docker logs <container_name_or_id>
```

Useful flags:
- `-f` (follow): Stream logs in real-time.
- `--tail N`: Show only the last N lines.
- `-t`: Show timestamps for each line.

---

### 2. Inspecting State (`docker inspect`)

To check why a container failed to start or crashed, inspect the state object:
```bash
docker inspect --format '{{.State.ExitCode}} {{.State.Error}}' <container_name>
```

An exit code of `137` typically indicates the container was terminated by the OOM (Out Of Memory) killer.

---

## Lab Tasks

### Task 1: Identify container startup error (`dkr-identify-startup-error`)
1. Start the lab session:
   ```bash
   tld start dkr-identify-startup-error
   ```
2. Inspect the logs of the failed container `crashing-app`:
   ```bash
   docker logs crashing-app
   ```
3. Extract the error token (`ERR_TOKEN_XY123`) from the output and write it to `~/docker-troubleshooting/errors/startup-token.txt`:
   ```bash
   mkdir -p "$HOME/docker-troubleshooting/errors"
   docker logs crashing-app 2>&1 | grep -o 'ERR_TOKEN_[A-Z0-9]*' > "$HOME/docker-troubleshooting/errors/startup-token.txt"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Identify container network error (`dkr-identify-network-error`)
1. Start the lab session:
   ```bash
   tld start dkr-identify-network-error
   ```
2. Inspect the logs of `api-client` to determine which port connection failed:
   ```bash
   docker logs api-client
   ```
3. Extract the port number (`9999`) and write it to `~/docker-troubleshooting/errors/network-port.txt`:
   ```bash
   mkdir -p "$HOME/docker-troubleshooting/errors"
   echo "9999" > "$HOME/docker-troubleshooting/errors/network-port.txt"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
