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
