# Systemd Stack Recovery Capstone Challenge

In production incidents, multi-tier application stacks (e.g., Database -> Backend API -> Proxy) can fail to start due to misconfigured dependency declarations, missing environment variables, or invalid ordering requirements.

---

## Dependency & Recovery Audit Checklist

1. **Ordering (`After=` / `Before=`)**: Verify dependent services start in chronological sequence.
2. **Requirements (`Requires=` / `Wants=`)**: Ensure core service dependencies are declared.
3. **Execution Environment**: Check `ExecStart=`, `EnvironmentFile=`, and file path access.
4. **Validation**: Test unit file syntax using `systemd-analyze verify`.

---

## Lab Tasks

### Task 1: Recover Broken systemd Service Stack (`lnx-recover-broken-systemd-stack`)
1. Start the lab:
   ```bash
   tld start lnx-recover-broken-systemd-stack
   ```
2. Create directory `$HOME/systemd-challenge`.
3. Create `$HOME/systemd-challenge/db.service` with `[Unit]`, and `[Service]` containing `Type=simple` and `ExecStart=/bin/echo DB Ready`.
4. Create `$HOME/systemd-challenge/app.service` with `[Unit]` containing `Requires=db.service` and `After=db.service`, and `[Service]` containing `ExecStart=/bin/echo App Ready`.
5. Validate your solution:
   ```bash
   tld check
   ```
