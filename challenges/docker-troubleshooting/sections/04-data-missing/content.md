## Data Missing

When running databases inside containers, persistence is crucial. A common mistake is misconfiguring volume paths inside the `docker-compose.yml` or container launch commands.

---

### Mismatched Volume Paths

In Postgres, data is stored by default at `/var/lib/postgresql/data`. If you create a bind mount mapping a local folder to a different path inside the container (e.g. `/var/lib/postgresql`), Postgres will not find the configuration or existing records and will bootstrap a brand new empty database directory in the container's scratch space.

If you bring down the container with `docker compose down` and restart it, any data created during the session will disappear.

---

## Lab Tasks

### Task 1: Recover persistent data (`dkr-recover-persistent-data`)
1. Start the lab session:
   ```bash
   tld start dkr-recover-persistent-data
   ```
2. Navigate to `~/docker-troubleshooting/persistence/`:
   ```bash
   cd "$HOME/docker-troubleshooting/persistence"
   ```
3. Inspect the existing `docker-compose.yml` to observe the erroneous mount path:
   ```bash
   cat docker-compose.yml
   ```
4. Update `docker-compose.yml` so that `./postgres_data` is mounted to the correct Postgres data directory (`/var/lib/postgresql/data`):
   ```yaml
   cat << 'EOF' > docker-compose.yml
   version: "3.8"

   services:
     db:
       image: postgres:15-alpine
       environment:
         - POSTGRES_PASSWORD=secret
       volumes:
         - ./postgres_data:/var/lib/postgresql/data
   EOF
   ```
5. Apply the updated volume mapping:
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
