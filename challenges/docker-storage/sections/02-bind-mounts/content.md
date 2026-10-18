## Bind Mounts

A **bind mount** maps a specific file or directory on your host machine to a path inside a container. Since the files reside on the host filesystem, any changes made on the host are immediately visible inside the container, and vice versa.

---

## 1. Syntax for Bind Mounts

You can configure a bind mount using either the `-v` (or `--volume`) flag or the newer, more explicit `--mount` flag.

### Using `-v` (Shortcut Syntax)
```bash
docker run -d -v /path/on/host:/path/in/container nginx
```

### Using `--mount` (Explicit Syntax)
```bash
docker run -d --mount type=bind,source=/path/on/host,target=/path/in/container nginx
```
* **`type=bind`**: Specifies that this is a bind mount (rather than a named volume).
* **`source` / `src`**: The absolute path to the directory or file on the host machine.
* **`target` / `dst`**: The path inside the container where the files will be mounted.

---

## Lab Tasks

### Task 1: Edit a mounted file (`dkr-edit-mounted-file`)
1. Start the lab session:
   ```bash
   tld start dkr-edit-mounted-file
   ```
2. A background container named `notes-viewer` is running with the host directory `~/docker-mount-test/` mapped to `/notes/` inside the container.
3. Update the file `~/docker-mount-test/notes.txt` on your host machine to contain exactly `DevLab Rocks`:
   ```bash
   echo "DevLab Rocks" > "$HOME/docker-mount-test/notes.txt"
   ```
4. Verify the file contents reflected inside the running container:
   ```bash
   docker exec notes-viewer cat /notes/notes.txt
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Share host directory (`dkr-share-host-directory`)
1. Start the lab session:
   ```bash
   tld start dkr-share-host-directory
   ```
2. Start a background container named `nginx-mount` using the `nginx:alpine` image with port `8085:80` and the host directory `~/docker-share` mounted to `/usr/share/nginx/html`:
   ```bash
   docker run -d --name nginx-mount -p 8085:80 -v "$HOME/docker-share:/usr/share/nginx/html" nginx:alpine
   ```
3. Verify the container is running and serving content:
   ```bash
   curl -s http://localhost:8085
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
