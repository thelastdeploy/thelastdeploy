## Compose Environment Variables

Hardcoding configurations, connection strings, or sensitive passwords inside your `docker-compose.yml` file is a security risk and makes it difficult to adjust settings for different environments (like local development, staging, or production).

Docker Compose supports **environment variable interpolation**, allowing you to load values dynamically from a `.env` file located in the same directory as your `docker-compose.yml`.

---

### Using a `.env` file

If you have a `.env` file:
```env
DB_PASSWORD=mysecretpassword
DB_NAME=production_db
```

You can reference these variables in your `docker-compose.yml` using the `${VARIABLE_NAME}` syntax:

```yaml
version: "3.8"

services:
  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_DB=${DB_NAME}
```

When you run `docker compose up`, Docker Compose automatically:
1. Looks for a file named `.env` in the current directory.
2. Replaces `${DB_PASSWORD}` and `${DB_NAME}` with the corresponding values before starting the containers.

---

## Lab Tasks

### Task 1: Use .env file for configuration (`dkr-fix-env-configuration`)
1. Start the lab session:
   ```bash
   tld start dkr-fix-env-configuration
   ```
2. Navigate to `~/docker-compose/env-vars/`:
   ```bash
   cd "$HOME/docker-compose/env-vars"
   ```
3. Inspect the existing `docker-compose.yml` file:
   ```bash
   cat docker-compose.yml
   ```
   Notice that both `app` and `db` reference `${DB_PASSWORD}`.
4. Create the `.env` file containing the required database password:
   ```bash
   echo "DB_PASSWORD=supersecure123" > .env
   ```
5. Start the stack in detached mode:
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
