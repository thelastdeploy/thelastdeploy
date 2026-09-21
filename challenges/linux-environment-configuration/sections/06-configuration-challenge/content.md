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
2. Complete the environment configuration capstone challenge.
3. Fix configuration parameters in `$HOME/config-challenge/app.conf`, create `$HOME/config-challenge/.env`, and record `APP_CONFIG_STATUS: VERIFIED` in `$HOME/config-challenge/fix_report.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
