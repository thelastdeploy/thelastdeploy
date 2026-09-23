# Network Service & Port Hardening

Securing network access requires hardening SSH daemon configuration, disabling outdated protocols, and restricting listening ports to authorized subnets.

---

## 1. SSH Daemon Hardening (`/etc/ssh/sshd_config`)

Production SSH hardening guidelines:

```text
# Disable direct root login over SSH
PermitRootLogin no

# Disable password authentication (force SSH public key authentication)
PasswordAuthentication no

# Disable empty passwords
PermitEmptyPasswords no

# Limit max authentication attempts
MaxAuthTries 3

# Disable legacy X11 forwarding
X11Forwarding no
```

Apply changes safely:

```bash
# Test SSH configuration syntax before restarting daemon
sshd -t

# Reload SSH service
systemctl reload sshd
```

---

## 2. Restricting Exposed Ports

Close unnecessary open ports using local firewalls (`iptables` / `ufw`):

```bash
# List all active listening TCP and UDP sockets
ss -tulpn

# Block exposed port (e.g., port 6379 Redis) from external interfaces
iptables -A INPUT -p tcp --dport 6379 ! -s 127.0.0.1 -j DROP
```

---

## Summary

Disabling root SSH access and restricting external network ports minimizes attack surface exposure.

---

## Lab Tasks

### Task 1: Harden Network Services and SSH (`lnx-harden-network-services`)
1. Start the lab:
   ```bash
   tld start lnx-harden-network-services
   ```
2. Create directory `$HOME/net-sec-test`.
3. Document SSH hardening parameters (`PermitRootLogin no`, `PasswordAuthentication no`).
4. Write output summary `SSHD_CONFIG_HARDENED` to `$HOME/net-sec-test/sshd_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Restrict Unnecessary Network Ports (`lnx-restrict-unnecessary-ports`)
1. Start the lab:
   ```bash
   tld start lnx-restrict-unnecessary-ports
   ```
2. Create directory `$HOME/net-sec-test`.
3. Inspect listening sockets and document port restriction firewall rules.
4. Write output line `UNNECESSARY_PORTS_RESTRICTED` to `$HOME/net-sec-test/ports_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
