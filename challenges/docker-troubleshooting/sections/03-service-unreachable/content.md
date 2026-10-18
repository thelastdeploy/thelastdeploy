## Service Unreachable

When deploying microservices or multi-container stacks, one container often needs to call an API or database in another. If the connection fails with "Connection Refused" or "Host Unreachable", you are likely dealing with network isolation.

---

### The Default Network vs. Custom Bridges

By default, standalone containers launched with `docker run` are attached to the default bridge network (`bridge`). While they can communicate via IP address, they **cannot resolve each other by name (DNS resolution)**.

In contrast, containers in a custom user-defined network:
1. Support automatic service discovery (DNS name resolution).
2. Are securely isolated from other bridges.

If a `web` container needs to talk to a `db` container, both MUST be connected to the exact same user-defined network. If they reside on different networks, they cannot establish direct IP connections.

---

## Lab Tasks

### Task 1: Restore service connectivity (`dkr-restore-service-connectivity`)
1. Start the lab session:
   ```bash
   tld start dkr-restore-service-connectivity
   ```
2. Navigate to `~/docker-troubleshooting/connectivity/`:
   ```bash
   cd "$HOME/docker-troubleshooting/connectivity"
   ```
3. Inspect the current `docker-compose.yml` to see the network isolation between `web` and `db`:
   ```bash
   cat docker-compose.yml
   ```
4. Update `docker-compose.yml` so that both `web` and `db` connect to the same network (e.g. `app-net`):
   ```yaml
   cat << 'EOF' > docker-compose.yml
   version: "3.8"

   services:
     web:
       image: nginx:alpine
       ports:
         - "8085:80"
       networks:
         - app-net

     db:
       image: postgres:15-alpine
       environment:
         - POSTGRES_PASSWORD=secret
       networks:
         - app-net

   networks:
     app-net:
   EOF
   ```
5. Apply the updated configuration:
   ```bash
   docker compose up -d
   ```
6. Verify running services:
   ```bash
   docker compose ps
   ```
7. Validate your solution:
   ```bash
   tld check
   ```
