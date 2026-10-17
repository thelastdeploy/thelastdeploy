# Production Volume Expansion Capstone Challenge

In this capstone challenge, a production application server is running out of disk space. The system uses LVM storage and has unallocated capacity in its Volume Group. Your task is to safely expand the Logical Volume and underlying filesystem online without service downtime.

---

## Production Expansion Workflow

1. **Verify VG Capacity**: Check free space in Volume Group (`vgs` / `vgdisplay`).
2. **Extend LV & Filesystem**: Execute `lvextend -L +<size> -r /dev/<vg>/<lv>`.
3. **Verify Filesystem Capacity**: Confirm expanded storage using `df -h <mount_point>`.

---

## Lab Tasks

### Task 1: Expand Production Application Storage Capstone (`lnx-expand-production-storage`)
1. Start the lab:
   ```bash
   tld start lnx-expand-production-storage
   ```
2. Create directory `$HOME/lvm-capstone`:
   ```bash
   mkdir -p "$HOME/lvm-capstone"
   ```
3. Write storage expansion automation script `$HOME/lvm-capstone/expand_app.sh`:
   ```bash
   cat << 'EOF' > "$HOME/lvm-capstone/expand_app.sh"
   #!/usr/bin/env bash
   # Online expansion of logical volume and filesystem
   lvextend -L +5G -r /dev/vg_app/lv_data
   EOF
   chmod +x "$HOME/lvm-capstone/expand_app.sh"
   ```
4. Write summary line `PRODUCTION_EXPANSION_COMPLETE` to `$HOME/lvm-capstone/expansion.log`:
   ```bash
   echo "PRODUCTION_EXPANSION_COMPLETE" > "$HOME/lvm-capstone/expansion.log"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
