## Multi-Service Applications

A primary advantage of Docker Compose is that it configures a single default bridge network for your entire stack. Every container defined in your `docker-compose.yml` can communicate with every other container on that network using **service names as hostnames**.

---

### Service Discovery & DNS

For example, suppose we define a web application and a Postgres database:
```yaml
version: "3.8"

services:
  web:
    image: my-app-web:latest
    ports:
      - "8080:80"
  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_PASSWORD=secret
```

Inside the `web` container, your application code does not need to know the database's IP address. It can simply connect to:
`postgresql://db:5432`

Docker's internal DNS resolver automatically intercepts the hostname `db` and routes traffic to the database container.

---

### Scaling Services

With Docker Compose, you can easily scale a service to run multiple instances:
```bash
docker compose up -d --scale web=2
```

This starts a second replica of the `web` service. Docker Compose assigns them sequential names (e.g. `project_web_1` and `project_web_2`).
Note: If you scale a service, you cannot bind it to a static host port in the compose file (since both replicas would try to bind to the same host port, causing a collision). Instead, you let Docker map them dynamically or route them through a load balancer (like Nginx or Traefik).

---

## Lab Tasks

### Task 1: Run web and database services
1. Start the task:
   ```bash
   tld start dkr-run-web-and-db
   ```
2. Navigate to `~/docker-compose/multi-service/`.
3. Create a `docker-compose.yml` defining two services:
   - `web`: using `nginx:alpine`, ports `"8081:80"`
   - `db`: using `postgres:15-alpine`
   - Define the following environment variables for `db`:
     - `POSTGRES_USER=admin`
     - `POSTGRES_PASSWORD=secret`
     - `POSTGRES_DB=mydb`
4. Start the stack in detached mode using `docker compose up -d`.
5. Run the validator:
   ```bash
   tld check
   ```

### Task 2: Inspect and scale Compose services
1. Start the next task:
   ```bash
   tld start dkr-inspect-compose-services
   ```
2. Navigate to `~/docker-compose/multi-service/`. A preconfigured compose file is provided.
3. Scale the `web` service to 2 instances.
4. Run the validator:
   ```bash
   tld check
   ```
