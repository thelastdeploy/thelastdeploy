## Running Containers

To run applications successfully using Docker, you need to understand how to name your containers for easy management and how to start them in background (detached) mode.

---

## 1. Naming Containers (`--name` flag)

By default, if you do not specify a name for a container, Docker automatically generates a random name (like `determined_bohr` or `friendly_hawking`). For script automation, debugging, and general container management, you should explicitly set a human-readable name using the `--name` flag:

```bash
docker run --name my-static-nginx -d nginx
```

Once a container is named, you can reference it directly in commands like `docker stop my-static-nginx` or `docker rm my-static-nginx`.

---

## 2. Detached Mode (`-d` flag)

Running a container in the foreground is useful for interactive shells, but for servers or background tasks, you want them running in the background. Use the `-d` (detached) flag to instruct Docker to run the container in the background:

```bash
docker run -d alpine sleep 100
```

---

## Lab Tasks

### Task 1: Name a container
1. Start the lab in your terminal:
   ```bash
   tld start dkr-name-a-container
   ```
2. Start an `alpine` container in detached mode (background) named `custom-app` that runs `sleep 1000`.
3. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Run a detached container
1. Start the lab in your terminal:
   ```bash
   tld start dkr-run-detached-container
   ```
2. Start an `alpine` container running in detached mode named `background-sleeper` that executes `sleep 500`.
3. Verify the task:
   ```bash
   tld check
   ```
