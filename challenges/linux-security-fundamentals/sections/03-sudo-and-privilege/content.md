# Sudo and Delegated Privilege

The `sudo` (Superuser Do) utility allows permitted users to execute system administration commands with root privileges without logging into a persistent root shell.

## 1. Inspecting Sudo Privileges (`sudo -l`)

To view the commands you are authorized to run with elevated privileges:

```bash
sudo -l
```

## 2. The `/etc/sudoers` Architecture

Rules in `/etc/sudoers` and modular drop-in files in `/etc/sudoers.d/` follow this format:

```sudoers
# user  hosts = (run_as_users : run_as_groups) [NOPASSWD:] commands
alice   ALL = (ALL:ALL) ALL
bob     ALL = (ALL) /usr/bin/systemctl restart nginx
deploy  ALL = (ALL) NOPASSWD: ALL
```

## 3. Auditing Security Risks

- **`NOPASSWD: ALL`**: Grants un-authenticated full superuser access. If an application service account assigned this rule is compromised, the entire host is compromised.
- **Wildcards in Sudo Rules**: Granting sudo access to binaries that support shell escapes (like `vim`, `find`, `less`, `awk`) allows users to break out into a root shell.

---

## Lab Tasks

### Task 1: Inspect Sudo Privileges with Sudo List (`lnx-inspect-sudo-access`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-sudo-access
   ```
2. Inspect user sudo privilege specifications.
3. Create an executable script at `$HOME/sec-test/check_sudo.sh` running `sudo -l` to list allowed commands.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Permissive Sudoers Rules (`lnx-investigate-privilege-access`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-privilege-access
   ```
2. Audit permissive sudoers configurations.
3. Identify users with full `ALL=(ALL:ALL) ALL` NOPASSWD privileges and save their username to `$HOME/sec-test/permissive_user.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
