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
