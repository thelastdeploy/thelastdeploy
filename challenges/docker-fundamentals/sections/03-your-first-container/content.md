## Your First Container

Now that we understand the difference between images (blueprints) and containers (instances), let's instantiate one ourselves.

---

## 1. Running a Container (`docker run`)

The most fundamental Docker command is `docker run`. Under the hood, this command:
1. Checks if the requested image is available locally.
2. If not, pulls (downloads) it automatically from Docker Hub.
3. Creates a new writeable container layer.
4. Starts the container and executes its default command.

```bash
docker run hello-world
```

---

## 2. Interactive Containers (`-it` flags)

By default, containers run in the background or print their output and exit. If you want to interactively explore inside a container (like launching a shell inside a mini-OS), you need two flags:
* `-i` (interactive): Keep STDIN open so you can type commands.
* `-t` (tty): Allocate a pseudo-TTY (a terminal interface).

To run an interactive Ubuntu shell, run:
```bash
docker run -it ubuntu bash
```
Once inside, you are in an isolated Ubuntu container file system! Type `exit` to stop the container and return to your host shell.

---

## Lab Tasks

### Task 1: Run alpine container (`dkr-run-alpine-container`)
1. Start the lab session:
   ```bash
   tld start dkr-run-alpine-container
   ```
2. Run a container named `my-alpine-run` using the `alpine` image that echoes `Hello from Alpine`:
   ```bash
   docker run --name my-alpine-run alpine echo "Hello from Alpine"
   ```
3. Verify the container execution and output logs:
   ```bash
   docker ps -a --filter name=my-alpine-run
   docker logs my-alpine-run
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Run hello-world container (`dkr-run-hello`)
1. Start the lab session:
   ```bash
   tld start dkr-run-hello
   ```
2. Run the official `hello-world` container:
   ```bash
   docker run hello-world
   ```
3. Verify the container executed:
   ```bash
   docker ps -a --filter ancestor=hello-world
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
