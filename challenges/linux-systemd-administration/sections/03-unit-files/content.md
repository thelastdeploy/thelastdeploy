# Unit File Structure & Custom Services

`systemd` service unit files define how a background process is executed, monitored, and integrated into the operating system. Unit files reside in `/lib/systemd/system/` (system default) or `/etc/systemd/system/` (administrator overrides and custom units).

---

## 1. Anatomy of a `.service` Unit File

A service unit file consists of three main sections:

```ini
[Unit]
Description=My Custom Application Service
After=network.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/myapp --config /etc/myapp.conf
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartSec=5s
User=nobody
Group=nogroup

[Install]
WantedBy=multi-user.target
```

---

## 2. Key Directives Explained

- **`ExecStart=`**: Command line to execute when starting the service.
- **`Type=simple`**: Process started by ExecStart is the main daemon process.
- **`Restart=on-failure`**: Automatically restart process if it exits with non-zero status.
- **`WantedBy=multi-user.target`**: Enables service under multi-user non-graphical boot state.

---

## Summary

Custom unit files in `/etc/systemd/system/` allow custom application binaries to be supervised with native auto-restart and boot startup capabilities.

---

## Lab Tasks

### Task 1: Create Custom systemd Service (`lnx-create-custom-service`)
1. Start the lab:
   ```bash
   tld start lnx-create-custom-service
   ```
2. Create directory `$HOME/unit-test`.
3. Create unit file `$HOME/unit-test/custom-app.service` containing:
4. - `[Unit]` with `Description=Custom App`
5. - `[Service]` with `Type=simple`, `ExecStart=/usr/bin/echo Hello`, `Restart=on-failure`
6. - `[Install]` with `WantedBy=multi-user.target`
7. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Inspect Unit Configuration (`lnx-inspect-unit-configuration`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-unit-configuration
   ```
2. Create directory `$HOME/unit-test`.
3. Inspect unit file directives of systemd service using `systemctl cat` or `systemd-analyze cat-config`.
4. Output extracted line `EXEC_START_FOUND` into `$HOME/unit-test/directives.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
