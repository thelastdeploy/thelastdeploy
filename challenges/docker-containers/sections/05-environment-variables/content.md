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

### Task 1: Fix missing environment variable
1. Start the lab in your terminal:
   ```bash
   tld start dkr-fix-missing-env-var
   ```
2. Your goal is to start a background (detached) container named `db-connector` using the `alpine` image running `sleep 1000`.
3. The container must have the environment variable `DB_HOST` set to `database.internal` to pass validation.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Run with environment variables
1. Start the lab in your terminal:
   ```bash
   tld start dkr-run-with-env-var
   ```
2. Start a detached container named `env-app` using the `alpine` image running `sleep 1000`.
3. Pass two environment variables to it:
   - `APP_ENV` set to `production`
   - `DEBUG` set to `false`
4. Verify the task:
   ```bash
   tld check
   ```
