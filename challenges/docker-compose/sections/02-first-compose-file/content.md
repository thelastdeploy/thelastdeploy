## Your First Compose File

The structure of a `docker-compose.yml` file is straightforward. It is written in YAML, which relies on indentation (2 spaces) to define hierarchy.

---

### Anatomy of `docker-compose.yml`

Here is a simple compose file running a single service:
```yaml
version: "3.8"

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
```

Let's break down each key:
- **`version`**: Specifies the version of the Docker Compose schema. `"3.8"` is a widely used and stable version.
- **`services`**: Defines the list of containers you want to build or pull. Each child under `services` is the name of that service (e.g., `web` or `db`).
- **`image`**: Specifies the pre-built Docker image to use for the container.
- **`ports`**: Maps ports from the host machine to the container, in the format `"HOST_PORT:CONTAINER_PORT"`. Always place port mappings inside quotes to prevent YAML parsing errors with certain formats.

---

### Launching the Stack

Once you have written a valid `docker-compose.yml` in a directory, you can manage it with the following commands:
- **`docker compose up -d`**: Reads the compose file, pulls any missing images, creates the default network and volumes, and starts the container stack in **detached mode** (in the background).
- **`docker compose ps`**: Lists the running containers associated with this specific compose project.
- **`docker compose stop`**: Suspends the running containers without deleting them.
- **`docker compose down`**: Stops and permanently removes the containers, networks, and configurations created by `up`.

---

## Lab Tasks

### Task 1: Create a basic Compose file (`dkr-create-compose-file`)
1. Start the lab session:
   ```bash
   tld start dkr-create-compose-file
   ```
2. Navigate to `~/docker-compose/first-compose/`:
   ```bash
   cd "$HOME/docker-compose/first-compose"
   ```
3. Create a `docker-compose.yml` file defining a `web` service using the `nginx:alpine` image with port mapping `8080:80`:
   ```yaml
   cat << 'EOF' > docker-compose.yml
   version: "3.8"
   services:
     web:
       image: nginx:alpine
       ports:
         - "8080:80"
   EOF
   ```
4. Verify the file contents:
   ```bash
   cat docker-compose.yml
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Launch the stack (`dkr-launch-compose-stack`)
1. Start the lab session:
   ```bash
   tld start dkr-launch-compose-stack
   ```
2. Navigate to `~/docker-compose/first-compose/` and start the compose stack in detached mode:
   ```bash
   cd "$HOME/docker-compose/first-compose"
   docker compose up -d
   ```
3. Verify that the service is running and serving traffic:
   ```bash
   curl -s http://localhost:8080
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
