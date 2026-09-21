# SSH Client Configuration

Instead of typing long connection parameters (hostnames, ports, custom keys, and usernames) repeatedly, you can configure connection aliases in `~/.ssh/config`.

## 1. Syntax of `~/.ssh/config`

```sshconfig
Host prod-web
    HostName 192.168.1.100
    User devops
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
```

With this configuration in place, connecting becomes as simple as:
```bash
ssh prod-web
```

OpenSSH automatically reads the parameters for `prod-web` and establishes the connection.

## 2. Permissions

The `~/.ssh/config` file must have strict read/write permissions for the current user (`600` or `644` depending on OpenSSH strict mode settings, but `600` is recommended).

---

## Lab Tasks

### Task 1: Configure SSH Client Connection Aliases (`lnx-configure-ssh-client`)
1. Start the lab:
   ```bash
   tld start lnx-configure-ssh-client
   ```
2. Configure client SSH host aliases in `$HOME/ssh-test/config`.
3. Define host `prod-server` with `HostName 127.0.0.1`, `User admin`, and `Port 2222`.
4. Validate your solution:
   ```bash
   tld check
   ```
