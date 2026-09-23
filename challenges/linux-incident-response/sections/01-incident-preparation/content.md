# Incident Context & Volatile State Preservation

Digital Forensics and Incident Response (DFIR) prioritizes evidence preservation over immediate system repair. When responding to a suspected security breach, first responders must follow an order of volatility—preserving transient RAM state, network connections, and process memory before modifying system files or rebooting.

---

## 1. The Incident Response Life Cycle

```text
+---------------------+     +-----------------------+     +--------------------------+
| 1. Observation      | --> | 2. State Preservation | --> | 3. Evidence Collection   |
|    & Context        |     |    (RAM, Sockets)     |     |    (Processes, Files)    |
+---------------------+     +-----------------------+     +--------------------------+
                                                                       |
                                                                       v
+---------------------+     +-----------------------+     +--------------------------+
| 6. Containment &    | <-- | 5. Scope & Impact     | <-- | 4. Timeline Construction |
|    Safe Recovery    |     |    Assessment         |     |    & Log Correlation     |
+---------------------+     +-----------------------+     +--------------------------+
```

---

## 2. Order of Volatility (RFC 3227)

Evidence must be collected from most volatile to least volatile:

1. **Memory & Sockets**: RAM contents, open TCP/UDP connections (`ss -anp`), routing cache.
2. **Process State**: Running processes (`ps auxf`), process environment (`/proc/<pid>/environ`), open handles (`lsof`).
3. **System Logs & Auth**: `/var/log/auth.log`, `journalctl`, system audit logs (`/var/log/audit/`).
4. **Disk Storage**: Inode metadata, raw block storage, persistence files.

---

## 3. Preserving Volatile Evidence Non-Destructively

```bash
# Capture active logged-in users and uptime
w > /tmp/evidence_w.txt

# Capture volatile network socket connections with PIDs
ss -tulpn > /tmp/evidence_sockets.txt

# Capture full process tree
ps auxf > /tmp/evidence_pstree.txt

# Capture system login history
last -a > /tmp/evidence_login_history.txt
```

---

## Summary

Preserving volatile RAM state (`ss`, `ps auxf`, `/proc`) before rebooting ensures critical forensic evidence is not lost.

---

## Lab Tasks

### Task 1: Establish Incident Context and Initial Observation (`lnx-establish-incident-context`)
1. Start the lab:
   ```bash
   tld start lnx-establish-incident-context
   ```
2. Create directory `$HOME/ir-test`.
3. Perform non-destructive incident observation (`w`, `who`, `uptime`).
4. Write observation summary line `INCIDENT_CONTEXT_ESTABLISHED` to `$HOME/ir-test/context.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Preserve Volatile System State (`lnx-preserve-system-state`)
1. Start the lab:
   ```bash
   tld start lnx-preserve-system-state
   ```
2. Create directory `$HOME/ir-test`.
3. Capture volatile system state (sockets, processes, login history).
4. Write evidence output line `VOLATILE_SYSTEM_STATE_PRESERVED` to `$HOME/ir-test/volatile_state.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
