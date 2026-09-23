# Network Security & Remote Administration

Hardening SSH access, enforcing key-based authentication, configuring host firewall rules, and controlling network ingress.

Securing production servers requires strict access control at the network layer (firewall rule sets) and application layer (SSH configuration).

### Hardening Directives
- **SSH Hardening**: Disable password authentication (`PasswordAuthentication no`), disable root SSH (`PermitRootLogin no`), enforce public key authentication.
- **Firewall Policy**: Block all unsolicited incoming traffic except authorized administration ports (`22/tcp`, `80/tcp`, `443/tcp`).


---

## Lab Tasks

### Task 1: Secure Server Network (`lnx-secure-server-network`)
1. Start the lab:
   ```bash
   tld start lnx-secure-server-network
   ```
2. Create directory `$HOME/net-sec`.
3. Configure firewall policy to restrict inbound traffic to required production ports.
4. Write `STATEFUL_FIREWALL_RULES_CONFIGURED` into `$HOME/net-sec/firewall_hardening.log`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Manage Remote Administration (`lnx-manage-remote-administration`)
1. Start the lab:
   ```bash
   tld start lnx-manage-remote-administration
   ```
2. Enforce SSH key-only authentication, non-standard banners, and idle timeouts in `/etc/ssh/sshd_config`.
3. Configure explicit sudoers rule limits for administrative accounts.
4. Write `SSH_AND_SUDO_ACCESS_HARDENED` into `$HOME/net-sec/ssh_hardening.conf`.
5. Validate your solution:
   ```bash
   tld check
   ```
