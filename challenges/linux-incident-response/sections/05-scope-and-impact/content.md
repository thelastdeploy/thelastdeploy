# Incident Scope & Compromise Impact Assessment

Determining incident scope assesses whether the attacker accessed sensitive data, moved laterally to adjacent servers on the local network, or modified core system binary packages.

---

## 1. System Package Integrity Verification

Attackers often replace core system binaries (e.g. `ls`, `ps`, `netstat`) with trojaned versions. Package managers provide verification mechanisms:

```bash
# On Debian / Ubuntu (verify binary checksums against package database)
debsums -c 2>/dev/null

# On RHEL / CentOS / Fedora
rpm -V -a
```

---

## 2. Lateral Movement & Scope Audit

```bash
# Check active outbound connections to external IP ranges
ss -tun | grep -v 127.0.0.1

# Check user shell history files across home directories
cat /home/*/.bash_history /root/.bash_history 2>/dev/null | grep -E "ssh|scp|nc|curl"
```

---

## Summary

Package checksum verification (`debsums`/`rpm -V`) and shell history audits determine compromise scope and lateral movement.

---

## Lab Tasks

### Task 1: Determine Incident Scope and Lateral Movement (`lnx-determine-incident-scope`)
1. Start the lab:
   ```bash
   tld start lnx-determine-incident-scope
   ```
2. Create directory `$HOME/scope-test`.
3. Audit system package integrity (`debsums`/`rpm -V`) and outbound lateral network connections.
4. Write output summary line `INCIDENT_SCOPE_DETERMINED` into `$HOME/scope-test/incident_scope.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
