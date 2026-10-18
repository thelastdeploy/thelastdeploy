## Named Volumes

Unlike bind mounts, which expose the host directory structure directly to the container, **Named Volumes** are completely managed by Docker. They are stored in a dedicated, isolated directory on the host machine (`/var/lib/docker/volumes/` on Linux) and are the recommended way to persist data in Docker.

---

## 1. Managing Named Volumes

You can manage the lifecycle of volumes using `docker volume` commands:

* **Create a volume**:
  ```bash
  docker volume create my-volume
  ```
* **List all volumes**:
  ```bash
  docker volume ls
  ```
* **Remove a volume**:
  ```bash
  docker volume rm my-volume
  ```

---

## 2. Mounting Named Volumes inside a Container

To mount a volume, pass the volume name as the first argument in the `-v` flag:
```bash
docker run -d --name web -v my-volume:/usr/share/nginx/html nginx:alpine
```
If the volume `my-volume` does not exist when starting the container, Docker automatically creates it for you.

---

## Lab Tasks

### Task 1: Create volume (`dkr-create-volume`)
1. Start the lab session:
   ```bash
   tld start dkr-create-volume
   ```
2. Create a named volume named `app-data-vol` using the Docker volume management CLI:
   ```bash
   docker volume create app-data-vol
   ```
3. Verify that the volume was created:
   ```bash
   docker volume ls | grep app-data-vol
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Persist application data (`dkr-persist-application-data`)
1. Start the lab session:
   ```bash
   tld start dkr-persist-application-data
   ```
2. Start an initial container named `db-container` using the `nginx:alpine` image with the volume `db-storage-vol` mounted to `/usr/share/nginx/html`:
   ```bash
   docker run -d --name db-container -v db-storage-vol:/usr/share/nginx/html nginx:alpine
   ```
3. Write `Database persistent content` into `/usr/share/nginx/html/index.html` inside the container:
   ```bash
   docker exec db-container sh -c 'echo "Database persistent content" > /usr/share/nginx/html/index.html'
   ```
4. Stop and remove the initial container `db-container`:
   ```bash
   docker rm -f db-container
   ```
5. Create a new container named `db-container-new` mounting the same volume `db-storage-vol` to `/usr/share/nginx/html`:
   ```bash
   docker run -d --name db-container-new -v db-storage-vol:/usr/share/nginx/html nginx:alpine
   ```
6. Verify the persistent file inside the new container:
   ```bash
   docker exec db-container-new cat /usr/share/nginx/html/index.html
   ```
7. Validate your solution:
   ```bash
   tld check
   ```
