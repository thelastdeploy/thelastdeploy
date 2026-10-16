# Configuration Capstone Challenge

In this final capstone challenge, you will fix a broken application configuration setup and configure its environment variable overrides.

## Challenge Tasks

1. **Fix Application Config File**: Update `$HOME/config-challenge/app.conf` to contain:
   - `DB_HOST=db.internal`
   - `PORT=8080`
2. **Create Environment File**: Create `$HOME/config-challenge/.env` populated with `APP_KEY=secret_key_123`.
3. **Generate Fix Report**: Create a report file at `$HOME/config-challenge/fix_report.txt` containing `APP_CONFIG_STATUS: VERIFIED`.

---

## Lab Tasks

### Task 1: Fix Misconfigured Application and Environment (`lnx-fix-misconfigured-application`)
1. Start the lab:
   ```bash
   tld start lnx-fix-misconfigured-application
   ```
2. Inspect the misconfigured configuration file at `$HOME/config-challenge/app.conf` and the environment template at `$HOME/config-challenge/.env.template`.
3. Update `$HOME/config-challenge/app.conf` so `DB_HOST=db.internal` and `PORT=8080`.
4. Create `$HOME/config-challenge/.env` using the template or with `APP_KEY=secret_key_123`.
5. Write `APP_CONFIG_STATUS: VERIFIED` to `$HOME/config-challenge/fix_report.txt`.
6. Validate your solution:
   ```bash
   tld check
   ```
