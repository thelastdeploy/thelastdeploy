# Access Control & Privilege Restriction

Enforcing the Principle of Least Privilege requires restricting user access, enforcing strong PAM (Pluggable Authentication Modules) policies, and configuring `/etc/sudoers` to prevent unauthorized privilege escalation.

---

## 1. Password & Login Security (`/etc/login.defs` & `/etc/shadow`)

Enforce password expiration and lock dormant user accounts:

```bash
# Set maximum password age to 90 days in /etc/login.defs
PASS_MAX_DAYS 90
PASS_MIN_DAYS 7
PASS_WARN_AGE 14

# Lock a compromised user account immediately
usermod -L username
# Or disable account shell
usermod -s /sbin/nologin username
```

---

## 2. Restricting Sudo Access (`/etc/sudoers`)

Avoid dangerous `ALL=(ALL) NOPASSWD: ALL` wildcard rules in `/etc/sudoers` or `/etc/sudoers.d/`:

```text
# Secure sudo entry granting specific command execution to webadmin group
%webadmin ALL=(ALL) NOPASSWD: /bin/systemctl restart nginx, /bin/systemctl status nginx
```

Always edit sudoer rules using `visudo` to validate syntax before saving!

---

## Summary

Least privilege access controls limit administrative power to explicit commands required for specific operational roles.

---

## Lab Tasks

### Task 1: Harden User Access Controls (`lnx-harden-user-access`)
1. Start the lab:
   ```bash
   tld start lnx-harden-user-access
   ```
2. Create directory `$HOME/access-test`.
3. Document user access hardening policies (password expiration, account locking, nologin shells).
4. Write output summary line `USER_ACCESS_HARDENED` to `$HOME/access-test/access_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Restrict Privileged Access with sudo (`lnx-restrict-privileged-access`)
1. Start the lab:
   ```bash
   tld start lnx-restrict-privileged-access
   ```
2. Create directory `$HOME/access-test`.
3. Document secure sudo configuration practices without wildcard NOPASSWD grants.
4. Write output line `SUDO_PRIVILEGES_RESTRICTED` to `$HOME/access-test/sudo_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
