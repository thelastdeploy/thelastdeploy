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

### Task 1: Create a basic Compose file
1. Start the first task:
   ```bash
   tld start dkr-create-compose-file
   ```
2. Navigate to `~/docker-compose/first-compose/`.
3. Create a file named `docker-compose.yml`.
4. Define a service named `web` using the `nginx:alpine` image and exposing host port `8080` mapped to container port `80`.
5. Run the validator:
   ```bash
   tld check
   ```

### Task 2: Launch the stack
1. Start the next task:
   ```bash
   tld start dkr-launch-compose-stack
   ```
2. Go to `~/docker-compose/first-compose/`.
3. Start the compose stack in detached mode.
4. Run the validator:
   ```bash
   tld check
   ```
