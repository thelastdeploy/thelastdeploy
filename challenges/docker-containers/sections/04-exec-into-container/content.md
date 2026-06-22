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

### Task 1: Fix file inside container
1. Start the lab in your terminal:
   ```bash
   tld start dkr-fix-file-inside-container
   ```
2. A container named `app-to-fix` is running. There is a file inside the container located at `/app/config.txt` that contains the text `STATUS=broken`.
3. Use `docker exec` (either interactively or directly running a command) to edit or rewrite that file inside the container so it contains `STATUS=fixed`.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Open container shell
1. Start the lab in your terminal:
   ```bash
   tld start dkr-open-container-shell
   ```
2. A background container named `interactive-shell-target` is running. There is an empty file at `/tmp/touchme` inside it.
3. Open a shell or execute a command inside `interactive-shell-target` to write the **hostname** of the container into `/tmp/touchme`.
   *Hint: You can obtain the container's internal hostname by running the `hostname` command inside the container.*
4. Verify the task:
   ```bash
   tld check
   ```
