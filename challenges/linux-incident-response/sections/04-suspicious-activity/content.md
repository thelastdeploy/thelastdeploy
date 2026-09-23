# Suspicious Process & Persistence Mechanism Investigation

Attackers establish persistence on compromised Linux systems to maintain long-term access across reboots. Forensic investigators audit standard persistence locations to identify backdoors, webshells, and unauthorized cron jobs.

---

## 1. Common Linux Persistence Mechanisms

| Persistence Location | Inspection Strategy | Common Indicators |
| :--- | :--- | :--- |
| **Cron Schedules** | `/etc/cron*`, `/var/spool/cron/crontabs/` | Obfuscated curl/wget reverse shells |
| **systemd Services** | `/etc/systemd/system/`, `~/.config/systemd/` | Custom `.service` files spawning rogue daemons |
| **Shell Profiles** | `~/.bashrc`, `~/.profile`, `/etc/profile.d/` | Malicious alias or LD_PRELOAD exports |
| **SSH Authorized Keys** | `~/.ssh/authorized_keys`, `/etc/ssh/authorized_keys` | Unauthorized public keys inserted by attacker |
| **System V / Init Scripts** | `/etc/rc.local`, `/etc/init.d/` | Legacy startup scripts |

---

## 2. Auditing Persistence Locations

```bash
# Check crontabs for all system users
for user in $(cut -f1 -d: /etc/passwd); do crontab -u "$user" -l 2>/dev/null; done

# Inspect recent custom systemd unit files
ls -la --time=atime /etc/systemd/system/

# Check user SSH authorized keys
find /home /root -name "authorized_keys" -exec ls -la {} + -exec cat {} +
```

---

## Summary

Auditing cron schedules, systemd unit files, shell profiles (`.bashrc`), and SSH keys (`authorized_keys`) exposes malicious persistence mechanisms.

---

## Lab Tasks

### Task 1: Investigate Suspicious Process Activity (`lnx-investigate-suspicious-process`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-suspicious-process
   ```
2. Create directory `$HOME/suspicious-test`.
3. Inspect suspicious process activity (unlinked deleted binaries, hidden network sockets).
4. Write output summary line `SUSPICIOUS_PROCESS_INVESTIGATED` to `$HOME/suspicious-test/process_analysis.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Malicious Persistence Mechanisms (`lnx-investigate-persistence-mechanism`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-persistence-mechanism
   ```
2. Create directory `$HOME/suspicious-test`.
3. Audit persistence locations (`/etc/cron*`, `/etc/systemd/system/`, `~/.bashrc`, `~/.ssh/authorized_keys`).
4. Write output summary `PERSISTENCE_MECHANISM_DISCOVERED` to `$HOME/suspicious-test/persistence_report.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
