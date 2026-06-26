## Why Docker Compose?

In modern software development, applications are rarely isolated single-process services. Instead, they are made up of multiple components:
- A **frontend** web interface (e.g. React/Next.js)
- A **backend** REST API (e.g. FastAPI, Node.js)
- A **database** for state storage (e.g. PostgreSQL, Redis)
- A **background worker** queue (e.g. Celery)

---

### The Problem: Imperative Shell Commands

To run all these parts together using standalone Docker commands, you would have to execute multiple imperative steps:
1. Create a custom bridge network:
   ```bash
   docker network create my-bridge-network
   ```
2. Launch the database container:
   ```bash
   docker run -d --name database --network my-bridge-network -e POSTGRES_PASSWORD=secret postgres:15-alpine
   ```
3. Launch the backend server:
   ```bash
   docker run -d --name backend --network my-bridge-network -p 8000:8000 -e DB_HOST=database my-backend-image
   ```
4. Launch the frontend server:
   ```bash
   docker run -d --name frontend --network my-bridge-network -p 3000:3000 my-frontend-image
   ```

Doing this manually is **error-prone, hard to document, and highly tedious** to share among developer teams or deploy to different environments. If a configuration or environment variable changes, every command has to be modified manually.

---

### The Solution: Declarative Multi-Container Orchestration

**Docker Compose** is a tool that allows you to define your entire multi-container application stack in a single, declarative YAML configuration file: `docker-compose.yml`.

With Compose, you define:
1. **Services**: The containers that make up your application (e.g., `web`, `api`, `db`).
2. **Networks**: The virtual networks connecting your services.
3. **Volumes**: Persistent storage mappings that persist data when containers stop or restart.

To spin up your entire application, you run a single command:
```bash
docker compose up -d
```

To stop all containers and teardown networks/volumes:
```bash
docker compose down
```

Docker Compose automatically handles the order of creation, network plumbing, volume mounts, and logs consolidation for your entire system.
