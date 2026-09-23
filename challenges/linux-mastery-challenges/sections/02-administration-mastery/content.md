# Administration Mastery

Demonstrate mastery over systemd service architecture, multi-tier dependency management, LVM volume groups, and stateful networking.

Administration mastery evaluates your ability to manage enterprise Linux servers: systemd target units, logical volume extension, network interface configuration, and package repository management.

### Administration Capabilities
- **Systemd**: Custom unit dependencies, socket activation, override drop-ins (`/etc/systemd/system/*.service.d/`).
- **Storage & Networking**: LVM Volume Group expansion, online XFS/ext4 resize, static routing, and netplan/NetworkManager profiles.


---

## Lab Tasks

### Task 1: Master Linux Administration (`lnx-master-linux-administration`)
1. Start the lab:
   ```bash
   tld start lnx-master-linux-administration
   ```
2. Create directory `$HOME/mastery-admin`.
3. Configure multi-service systemd target dependencies and persistent journalctl limits.
4. Write `SYSTEM_ADMINISTRATION_MASTERED` into `$HOME/mastery-admin/admin_mastery.log`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Master Network and Storage (`lnx-master-network-and-storage`)
1. Start the lab:
   ```bash
   tld start lnx-master-network-and-storage
   ```
2. Perform live LVM logical volume expansion, online filesystem resize, and interface route adjustments.
3. Write `NETWORK_AND_STORAGE_ORCHESTRATION_MASTERED` into `$HOME/mastery-admin/net_storage_mastery.log`.
4. Validate your solution:
   ```bash
   tld check
   ```
