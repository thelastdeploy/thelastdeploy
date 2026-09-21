# Environment-Driven Applications

Modern applications follow the **Twelve-Factor App methodology**, storing configuration in environment variables rather than hardcoding settings into codebase files or static property sheets.

## 1. Using `.env` Files

Local development and containerized environments often store environment key-value pairs in `.env` files:

```env
PORT=5000
LOG_LEVEL=debug
DATABASE_URL=postgres://user:pass@localhost:5432/db
```

Sourcing `.env` files in Bash:
```bash
set -a
source .env
set +a
```

The `-a` flag automatically exports all variables defined while active.

## 2. Inline Environment Overrides

You can supply one-off environment variables directly to an application command at execution time without exporting them into the parent shell:

```bash
PORT=9000 LOG_LEVEL=warn ./start_server.sh
```

---

## Lab Tasks

### Task 1: Configure Environment-Driven Applications (`lnx-configure-app-with-environment`)
1. Start the lab:
   ```bash
   tld start lnx-configure-app-with-environment
   ```
2. Configure environment-driven application execution scripts.
3. Create an executable launcher at `$HOME/env-test/run_app.sh` setting `PORT=5000` and `LOG_LEVEL=debug`.
4. Validate your solution:
   ```bash
   tld check
   ```
