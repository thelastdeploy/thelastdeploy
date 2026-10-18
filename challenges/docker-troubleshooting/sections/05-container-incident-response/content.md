## Container Incident Response

When a critical production app crashes repeatedly (known as a crash loop), you must act fast.

---

### Step-by-step Incident Triage

1. **Check if the container is running**:
   ```bash
   docker ps -a
   ```
2. **Review the latest log entries**:
   ```bash
   docker logs --tail 50 <container_name>
   ```
3. **Inspect the exit code**:
   An exit code of `1` indicates an application exception. Look for missing config files, invalid database credentials, or syntax bugs in scripts.
4. **Fix config/resource mismatches**:
   Most crash loops in Docker Compose are caused by missing files on the host that are expected to be mounted, or incorrect environment variables.

---

## Lab Tasks

### Task 1: Investigate a production incident (`dkr-investigate-production-incident`)
1. Start the lab session:
   ```bash
   tld start dkr-investigate-production-incident
   ```
2. Navigate to `~/docker-troubleshooting/incident/`:
   ```bash
   cd "$HOME/docker-troubleshooting/incident"
   ```
3. Create the required `config.json` file with valid content:
   ```bash
   echo '{"status": "ok"}' > config.json
   ```
4. Update `docker-compose.yml` to mount `./config.json` into `/etc/app/config.json`:
   ```yaml
   cat << 'EOF' > docker-compose.yml
   version: "3.8"
   services:
     app:
       image: alpine
       command: sh -c "if [ ! -f /etc/app/config.json ]; then echo FATAL - config.json not found at /etc/app/config.json >&2 && exit 1; else echo App running... && sleep 3600; fi"
       volumes:
         - ./config.json:/etc/app/config.json
   EOF
   ```
5. Launch the compose stack in detached mode:
   ```bash
   docker compose up -d
   ```
6. Verify the application container is running:
   ```bash
   docker compose ps
   ```
7. Validate your solution:
   ```bash
   tld check
   ```
