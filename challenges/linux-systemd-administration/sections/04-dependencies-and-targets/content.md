# Dependencies & System Targets

`systemd` manages service ordering and dependencies through relationship directives defined inside unit files. Targets act as synchronization points and system runlevels.

---

## 1. Dependency Directives

- **`Wants=`**: Weak dependency. If unit A wants unit B, starting A attempts to start B, but failure of B does not prevent A from running.
- **`Requires=`**: Strong dependency. If unit A requires unit B, starting A starts B, and failure of B immediately stops or fails A.
- **`After=`**: Ordering constraint. Ensures unit A starts *after* unit B finishes starting.
- **`Before=`**: Ordering constraint. Ensures unit A starts *before* unit B starts.

```ini
[Unit]
Description=Web Application
After=network.target postgresql.service
Requires=postgresql.service
Wants=redis.service
```

---

## 2. System Targets & Runlevels

System targets group multiple units together. Common targets include:

| Target | SysV Runlevel Equivalent | Purpose |
| :--- | :--- | :--- |
| `poweroff.target` | 0 | System shutdown |
| `rescue.target` | 1 | Single-user maintenance mode |
| `multi-user.target` | 3 | Multi-user non-graphical text mode |
| `graphical.target` | 5 | Multi-user graphical desktop mode |
| `reboot.target` | 6 | System reboot |

```bash
# Check current default boot target
systemctl get-default

# List dependencies of a unit
systemctl list-dependencies multi-user.target
```

---

## Summary

`After`/`Before` configure execution ordering, whereas `Wants`/`Requires` declare activation dependencies.

---

## Lab Tasks

### Task 1: Analyze Service Dependencies (`lnx-analyze-service-dependencies`)
1. Start the lab:
   ```bash
   tld start lnx-analyze-service-dependencies
   ```
2. Create directory `$HOME/target-test`.
3. Inspect dependencies of `multi-user.target` using `systemctl list-dependencies`.
4. Output summary line `DEPENDENCIES_ANALYZED` to `$HOME/target-test/deps.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate System Target (`lnx-investigate-system-target`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-system-target
   ```
2. Create directory `$HOME/target-test`.
3. Run `systemctl get-default` to determine default system boot target.
4. Write output `DEFAULT_TARGET: <target_name>` into `$HOME/target-test/target_info.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
