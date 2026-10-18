## Executing into Containers

Sometimes you need to debug a running container by checking the filesystem internally, verifying configurations, or executing commands directly inside the container namespace. For this, Docker provides `docker exec`.

---

## 1. Running Commands Inside a Container (`docker exec`)

Unlike `docker run` (which starts a *new* container), `docker exec` runs a new command *inside* a container that is already running:

```bash
docker exec my-running-container ls -l /app
```

## 2. Opening a Shell inside a Container (`-it` flags)

If you want an interactive session with the container's environment (e.g. running bash or sh), you can use the `-it` flags:

```bash
docker exec -it my-running-container sh
```

This will log you into the container. You can check files, inspect network links, and exit when done.

---

## Lab Tasks

### Task 1: Fix file inside container (`dkr-fix-file-inside-container`)
1. Start the lab session:
   ```bash
   tld start dkr-fix-file-inside-container
   ```
2. A container named `app-to-fix` is running. There is a file inside the container located at `/app/config.txt` that contains the text `STATUS=broken`.
3. Use `docker exec` to update the file inside the container so it contains `STATUS=fixed`:
   ```bash
   docker exec app-to-fix sh -c 'echo "STATUS=fixed" > /app/config.txt'
   ```
4. Verify the file contents inside the container:
   ```bash
   docker exec app-to-fix cat /app/config.txt
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Open container shell (`dkr-open-container-shell`)
1. Start the lab session:
   ```bash
   tld start dkr-open-container-shell
   ```
2. A background container named `interactive-shell-target` is running. There is an empty file at `/tmp/touchme` inside it.
3. Execute a command inside `interactive-shell-target` to write the internal hostname of the container into `/tmp/touchme`:
   ```bash
   docker exec interactive-shell-target sh -c 'hostname > /tmp/touchme'
   ```
4. Verify the file contents inside the container:
   ```bash
   docker exec interactive-shell-target cat /tmp/touchme
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
