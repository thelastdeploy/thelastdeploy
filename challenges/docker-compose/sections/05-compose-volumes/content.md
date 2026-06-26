## Compose Volumes

Containers are ephemeral by nature. If a container crashes, is stopped, or is removed with `docker compose down`, any data stored within the container's file system is lost forever.

To persist data, Docker Compose uses **volumes**. The most common type is a **named volume**, which is fully managed by Docker and lives outside the container's lifecycle.

---

### Declaring Named Volumes

To use a named volume, you must:
1. Declare the volume under the top-level `volumes` key.
2. Mount the volume inside the service definition using the `volumes` list in the format `VOLUME_NAME:CONTAINER_PATH`.

Here is an example persisting Postgres database data:

```yaml
version: "3.8"

services:
  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_PASSWORD=secret
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```

Docker Compose will automatically create the volume when you run `docker compose up`. If you shut down the stack using `docker compose down`, the volume (and all your database files) remains intact. When you run `docker compose up` again, the data is automatically restored.

---

## Lab Tasks

### Task 1: Persist database data with named volumes
1. Start the task:
   ```bash
   tld start dkr-persist-database-data
   ```
2. Navigate to `~/docker-compose/volumes/`.
3. Create a `docker-compose.yml` declaring:
   - A service named `db` using `postgres:15-alpine` image.
   - An environment variable `POSTGRES_PASSWORD=secret` for `db`.
   - A top-level named volume called `db_data`.
   - Mount the `db_data` volume inside the `db` container at `/var/lib/postgresql/data`.
4. Run `docker compose up -d` to launch the stack.
5. Run the validator to confirm persistence configurations:
   ```bash
   tld check
   ```
