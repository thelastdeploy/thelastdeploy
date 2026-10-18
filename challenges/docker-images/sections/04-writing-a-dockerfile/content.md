## Writing a Dockerfile

A **Dockerfile** is a text document containing all the commands a user could call on the command line to assemble a Docker image.

---

## 1. Core Dockerfile Instructions

Here are the most common instructions used when authoring a Dockerfile:

* **`FROM`**: Sets the base image for subsequent instructions. Must be the first instruction.
  ```dockerfile
  FROM alpine:3.18
  ```
* **`RUN`**: Executes commands in a new layer on top of the current image and commits the results. Used to install packages, compile code, etc.
  ```dockerfile
  RUN apk add --no-cache curl
  ```
* **`COPY`**: Copies files or directories from the host build context into the container's filesystem.
  ```dockerfile
  COPY index.html /usr/share/nginx/html/
  ```
* **`WORKDIR`**: Sets the working directory for any subsequent `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, or `ADD` instructions.
  ```dockerfile
  WORKDIR /app
  ```
* **`ENV`**: Sets environment variables that persist inside the container at runtime.
  ```dockerfile
  ENV PORT=8080
  ```
* **`CMD`**: Specifies the default command to execute when a container starts. There should only be one `CMD` in a Dockerfile.
  ```dockerfile
  CMD ["python3", "app.py"]
  ```

---

## Lab Tasks

### Task 1: Create first Dockerfile (`dkr-create-first-dockerfile`)
1. Start the lab session:
   ```bash
   tld start dkr-create-first-dockerfile
   ```
2. Create the target directory and author a `Dockerfile` inside `~/docker-build/first-dockerfile/`:
   ```bash
   mkdir -p "$HOME/docker-build/first-dockerfile"
   cat << 'EOF' > "$HOME/docker-build/first-dockerfile/Dockerfile"
   FROM alpine:3.18
   ENV APP_COLOR=blue
   CMD ["echo", "Hello DevLab"]
   EOF
   ```
3. Verify file contents:
   ```bash
   cat "$HOME/docker-build/first-dockerfile/Dockerfile"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Fix broken Dockerfile (`dkr-fix-broken-dockerfile`)
1. Start the lab session:
   ```bash
   tld start dkr-fix-broken-dockerfile
   ```
2. In `~/docker-build/broken-dockerfile/Dockerfile`, fix the syntax error (change invalid instruction `RUNN` to `RUN`):
   ```bash
   sed -i 's/RUNN/RUN/' "$HOME/docker-build/broken-dockerfile/Dockerfile"
   ```
3. Verify the corrected Dockerfile:
   ```bash
   cat "$HOME/docker-build/broken-dockerfile/Dockerfile"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
