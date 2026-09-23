# System Containment & Safe Forensic Recovery

Containment prevents an attacker or active malware from communicating with Command-and-Control (C2) servers or expanding lateral movement, while preserving management access for remediation.

---

## 1. Network Containment (`iptables`)

Apply restrictive firewall rules to isolate the compromised system:

```bash
# Allow local loopback and management IP (e.g. 10.0.0.50)
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s 10.0.0.50 -j ACCEPT

# Drop all other inbound and outbound traffic
iptables -A INPUT -j DROP
iptables -A OUTPUT -d 10.0.0.50 -j ACCEPT
iptables -A OUTPUT -j DROP
```

---

## 2. Safe System Restoration

1. **Remove Persistence**: Delete malicious cron jobs, systemd units, and rogue SSH keys.
2. **Rotate Credentials**: Change all local user passwords and rotate API keys/tokens.
3. **Reinstall Binaries**: Reinstall modified core packages from official repositories.
4. **Verify Integrity**: Re-run compliance verification scripts before restoring network access.

---

## Summary

Containment isolates compromised systems on the network (`iptables`), followed by credential rotation and persistence removal before service restoration.

---

## Lab Tasks

### Task 1: Contain Compromised System Safely (`lnx-contain-compromised-system`)
1. Start the lab:
   ```bash
   tld start lnx-contain-compromised-system
   ```
2. Create directory `$HOME/recovery-test`.
3. Apply containment rules isolating malicious outbound traffic while maintaining management access.
4. Write output line `COMPROMISED_SYSTEM_CONTAINED` to `$HOME/recovery-test/containment_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Restore System Safely from Known Good State (`lnx-restore-system-safely`)
1. Start the lab:
   ```bash
   tld start lnx-restore-system-safely
   ```
2. Create directory `$HOME/recovery-test`.
3. Execute safe system restoration (remove persistence, rotate credentials, verify integrity).
4. Write report summary line `SYSTEM_RESTORED_SAFELY` to `$HOME/recovery-test/restoration_report.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
