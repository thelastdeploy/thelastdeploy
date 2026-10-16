# Secure File Transfer (SCP and SFTP)

SSH provides two standard utilities for copying files between hosts over an encrypted tunnel: `scp` (Secure Copy) and `sftp` (SSH File Transfer Protocol).

## 1. Secure Copy (`scp`)

`scp` uses SSH data transfer and offers the same security as SSH.

### Copy Local File to Remote Destination:
```bash
scp app.tar.gz admin@192.168.1.50:/var/backups/
```

### Copy Remote File to Local Destination:
```bash
scp admin@192.168.1.50:/var/log/syslog ./remote-syslog.txt
```

### Copy Entire Directory Recursively:
```bash
scp -r ./config-files admin@192.168.1.50:/etc/config/
```

## 2. SSH File Transfer Protocol (`sftp`)

`sftp` provides an interactive shell session similar to traditional FTP:

```bash
sftp admin@192.168.1.50
```

Common interactive commands:
- `put local_file.txt [remote_path]` (Upload file to remote host)
- `get remote_file.txt [local_path]` (Download file to local host)
- `ls` / `cd` (Navigate remote directory structure)
- `bye` / `exit` (Close SFTP session)

### Automated Batch File Transfers:
Use the `-b` flag with a batch command file:
```bash
sftp -b sftp_commands.txt admin@192.168.1.50
```

---

## Lab Tasks

### Task 1: Copy Files Remotely using SCP (`lnx-copy-files-with-scp`)
1. Start the lab:
   ```bash
   tld start lnx-copy-files-with-scp
   ```
2. Create directory `$HOME/ssh-test`.
3. Create an executable script `$HOME/ssh-test/transfer_cmd.sh` that transfers `app.tar.gz` to remote destination `admin@10.0.0.50:/var/backups/` using `scp`.
4. Ensure the script has executable permissions (`chmod +x`).
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Transfer Files with SFTP Batch Commands (`lnx-transfer-files-with-sftp`)
1. Start the lab:
   ```bash
   tld start lnx-transfer-files-with-sftp
   ```
2. Create directory `$HOME/ssh-test`.
3. Create batch file `$HOME/ssh-test/sftp_batch.txt` containing:
   - Command to upload `local_config.json` to remote `/etc/app/config.json` (`put local_config.json /etc/app/config.json`)
   - Session termination command (`bye`)
4. Validate your solution:
   ```bash
   tld check
   ```
