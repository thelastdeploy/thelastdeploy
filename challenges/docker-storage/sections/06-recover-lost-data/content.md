## Recover Lost Data

Restoring data back into a Docker volume follows a similar pattern to backing it up. You start a temporary container that mounts the target volume and binds the host directory containing the backup archive, then extract the archive back into the volume.

---

## 1. How the Volume Restore Pattern Works

To restore files from a backup file (like `backup.tar`) on your host machine back into a volume:

1. **Volume Mount**: Mounts the destination volume (where you want the files to go) to a folder inside the container (e.g., `/volume`).
2. **Bind Mount**: Mounts the host directory containing your backup file to a folder inside the container (e.g., `/backup`).
3. **Extract Command**: Runs `tar` inside the container to extract the archive file from `/backup/` directly into `/volume`.

---

## 2. Command Template for Restoring

Here is the general template to perform a restore:

```bash
docker run --rm \
  -v <volume-name>:/volume \
  -v <host-backup-directory>:/backup \
  alpine tar xvf /backup/<backup-file-name>.tar -C /volume
```

### Breakdown of the template:
* **`--rm`**: Automatically deletes the temporary container once the extraction finishes.
* **`-v <volume-name>:/volume`**: Mounts the empty destination volume to `/volume` inside the container.
* **`-v <host-backup-directory>:/backup`**: Maps the host directory where your `backup.tar` is stored to `/backup` inside the container.
* **`alpine`**: The temporary container image used to run the restore tool.
* **`tar xvf /backup/<backup-file-name>.tar -C /volume`**: Extracts the contents of the tarball directly into the mounted volume (`-C /volume`).

---

## Lab Tasks

### Task 1: Restore application data (`dkr-restore-application-data`)
1. Start the lab session:
   ```bash
   tld start dkr-restore-application-data
   ```
2. An empty volume named `restored-db-vol` is created for you, and a backup archive `backup.tar` is located at `~/docker-restore-source/backup.tar`.
3. Run a temporary container to extract the archive contents into `restored-db-vol`:
   ```bash
   docker run --rm -v restored-db-vol:/volume -v "$HOME/docker-restore-source:/backup" alpine tar xvf /backup/backup.tar -C /volume
   ```
4. Verify the restored file inside the volume:
   ```bash
   docker run --rm -v restored-db-vol:/data alpine cat /data/db_state.json
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
