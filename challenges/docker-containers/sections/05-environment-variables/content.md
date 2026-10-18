## Environment Variables

Environment variables are the industry-standard way to pass configuration settings (like database hosts, credentials, ports, or debug levels) to applications running inside Docker containers.

---

## 1. Passing Environment Variables (`-e` / `--env` flag)

You can define variables at runtime using the `-e` flag:

```bash
docker run -d --name app -e APP_PORT=8080 -e APP_ENV=production node-app
```

Docker will inject these variables into the container's environment before starting the main process.

---

## 2. Using Environment Files (`--env-file` flag)

If you have many variables, passing them via `-e` makes the command long and messy. Instead, write them into a text file (e.g. `.env` or `config.env`):

```ini
# config.env
DB_HOST=database.internal
DB_USER=admin
DB_PASS=secret123
```

Then run the container referencing the file:
```bash
docker run -d --env-file config.env app-image
```

---

## Lab Tasks

### Task 1: Fix missing environment variable (`dkr-fix-missing-env-var`)
1. Start the lab session:
   ```bash
   tld start dkr-fix-missing-env-var
   ```
2. Start a background (detached) container named `db-connector` using the `alpine` image running `sleep 1000` with `DB_HOST` set to `database.internal`:
   ```bash
   docker run -d --name db-connector -e DB_HOST=database.internal alpine sleep 1000
   ```
3. Verify the environment variable inside the container:
   ```bash
   docker exec db-connector env | grep DB_HOST
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Run with environment variables (`dkr-run-with-env-var`)
1. Start the lab session:
   ```bash
   tld start dkr-run-with-env-var
   ```
2. Start a detached container named `env-app` using the `alpine` image running `sleep 1000` with `APP_ENV=production` and `DEBUG=false`:
   ```bash
   docker run -d --name env-app -e APP_ENV=production -e DEBUG=false alpine sleep 1000
   ```
3. Verify the environment variables inside the container:
   ```bash
   docker exec env-app env | grep -E 'APP_ENV|DEBUG'
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
