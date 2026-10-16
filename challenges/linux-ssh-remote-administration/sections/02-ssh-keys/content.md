# SSH Keys and Public Key Authentication

Public key authentication is significantly more secure than password authentication. It uses a cryptographic keypair: a **private key** (kept confidential on your client) and a **public key** (placed on remote servers).

## 1. Generating SSH Key Pairs (`ssh-keygen`)

Generate a modern, secure ED25519 keypair:
```bash
ssh-keygen -t ed25519 -C "admin@example.com" -f ~/.ssh/id_ed25519
```

- `-t`: Specifies key algorithm type (`ed25519` or `rsa`).
- `-C`: Adds a comment identifying the key.
- `-f`: Specifies output filename location.

## 2. Setting Up `authorized_keys`

To grant passwordless SSH access, append your public key (`id_ed25519.pub`) into the remote user's `~/.ssh/authorized_keys` file.

You can use `ssh-copy-id`:
```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@remote.example.com
```

Or copy the key manually:
```bash
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
```

## 3. Strict Permission Requirements

OpenSSH strictly enforces file permissions for security reasons:
- `~/.ssh` directory permissions must be `700` (`drwx------`).
- `~/.ssh/authorized_keys` permissions must be `600` (`-rw-------`).
- Private keys (`id_ed25519`) must be `600` (`-rw-------`).

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

---

## Lab Tasks

### Task 1: Generate an SSH Keypair (`lnx-generate-ssh-key`)
1. Start the lab:
   ```bash
   tld start lnx-generate-ssh-key
   ```
2. Create directory `$HOME/ssh-test/key_dir`.
3. Generate an ED25519 SSH keypair into `$HOME/ssh-test/key_dir/id_ed25519` without a passphrase (`ssh-keygen -t ed25519 -N "" -f $HOME/ssh-test/key_dir/id_ed25519`).
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Configure Authorized Keys and Permissions (`lnx-configure-key-authentication`)
1. Start the lab:
   ```bash
   tld start lnx-configure-key-authentication
   ```
2. Ensure directory `$HOME/ssh-test/server_home/.ssh` exists.
3. Append public key `$HOME/ssh-test/key_dir/id_ed25519.pub` to `$HOME/ssh-test/server_home/.ssh/authorized_keys`.
4. Restrict permissions on `$HOME/ssh-test/server_home/.ssh/authorized_keys` to `600` (`chmod 600`).
5. Validate your solution:
   ```bash
   tld check
   ```
