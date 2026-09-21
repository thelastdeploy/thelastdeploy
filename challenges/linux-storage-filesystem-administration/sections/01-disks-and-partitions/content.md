# Disks and Partitions

In Linux, all physical and virtual storage devices are represented as special block device files in the `/dev/` directory.

## 1. Naming Conventions for Block Devices

- **SATA / SCSI / USB Disks**: `/dev/sda`, `/dev/sdb`, `/dev/sdc` (Partitions: `/dev/sda1`, `/dev/sda2`).
- **NVMe Storage Devices**: `/dev/nvme0n1`, `/dev/nvme1n1` (Partitions: `/dev/nvme0n1p1`).
- **VirtIO Virtual Disks**: `/dev/vda`, `/dev/vdb` (Partitions: `/dev/vda1`).

## 2. Listing Block Devices (`lsblk`)

Display a tree representation of all attached block devices and mount points:

```bash
lsblk -f
```

## 3. Partitioning Schemes (MBR vs GPT)

- **MBR (Master Boot Record)**: Legacy scheme, maximum disk size 2TB, supports up to 4 primary partitions.
- **GPT (GUID Partition Table)**: Modern scheme, supports disks > 2TB, supports up to 128 partitions per drive.

Inspect partition tables:
```bash
fdisk -l /dev/sda
parted /dev/sda print
```

---

## Lab Tasks

### Task 1: Identify Storage Devices and Block Topology (`lnx-identify-storage-devices`)
1. Start the lab:
   ```bash
   tld start lnx-identify-storage-devices
   ```
2. Identify storage devices, block sizes, and disk topology.
3. List all block devices using `lsblk` and save output to `$HOME/storage-test/block_devices.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Inspect Disk Partition Tables (`lnx-inspect-disk-partitions`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-disk-partitions
   ```
2. Inspect partition table layouts and partition types.
3. Inspect disk partition layout using `fdisk -l` or `parted -l` and save details to `$HOME/storage-test/partition_info.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
