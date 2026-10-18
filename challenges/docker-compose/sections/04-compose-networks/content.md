## Compose Networks

By default, Docker Compose sets up a single network for your stack. All containers are connected to it, allowing them to communicate. However, in production environments, you often want to restrict network access to sensitive containers.

For instance, your **database** should never be directly accessible from the public internet or the frontend. Only the **backend API** should connect to the database.

---

### Custom Networks

You can define custom networks at the bottom of your compose file and assign services to them individually:

```yaml
version: "3.8"

services:
  web:
    image: nginx:alpine
    networks:
      - frontend-net
    ports:
      - "80:80"

  api:
    image: my-api-image:latest
    networks:
      - frontend-net
      - backend-net

  db:
    image: postgres:15-alpine
    networks:
      - backend-net

networks:
  frontend-net:
  backend-net:
```

In this setup:
- `web` and `api` are connected to `frontend-net`. They can communicate.
- `api` and `db` are connected to `backend-net`. They can communicate.
- `web` and `db` are isolated. They cannot resolve each other's names or connect directly.

---

## Lab Tasks

### Task 1: Connect services via custom networks (`dkr-connect-compose-services`)
1. Start the lab session:
   ```bash
   tld start dkr-connect-compose-services
   ```
2. Navigate to `~/docker-compose/networks/`:
   ```bash
   cd "$HOME/docker-compose/networks"
   ```
3. Create a `docker-compose.yml` file configuring `web`, `api`, and `db` across `frontend-net` and `backend-net`:
   ```yaml
   cat << 'EOF' > docker-compose.yml
   version: "3.8"

   services:
     web:
       image: nginx:alpine
       networks:
         - frontend-net
       ports:
         - "8082:80"

     api:
       image: nginx:alpine
       networks:
         - frontend-net
         - backend-net

     db:
       image: postgres:15-alpine
       networks:
         - backend-net
       environment:
         - POSTGRES_PASSWORD=secret

   networks:
     frontend-net:
     backend-net:
   EOF
   ```
4. Start the stack in detached mode:
   ```bash
   docker compose up -d
   ```
5. Verify running containers:
   ```bash
   docker compose ps
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
