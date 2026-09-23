# Container Layered Filesystems & OverlayFS

Container images use copy-on-write (COW) union filesystems such as **OverlayFS** to combine multiple read-only image layers with a single writable container layer.

---

## 1. OverlayFS Architecture

```text
Merged Directory View (/var/lib/docker/overlay2/merged)
+-------------------------------------------------------------+
| Writable Upper Layer (container modifications & new files)   |
+-------------------------------------------------------------+
| Read-Only Lower Layer 2 (App binaries & dependencies)        |
+-------------------------------------------------------------+
| Read-Only Lower Layer 1 (Base OS Image: Ubuntu / Alpine)     |
+-------------------------------------------------------------+
```

---

## 2. Mounting an OverlayFS Union Mount

OverlayFS requires four directory parameters:

- **`lowerdir`**: Read-only image layers (colon-separated for multiple layers).
- **`upperdir`**: Writable container layer where new/modified files are saved.
- **`workdir`**: Internal filesystem state directory used by kernel during atomic operations.
- **`merged`**: Combined unified view exposed to the container root filesystem.

```bash
# Create OverlayFS structure
mkdir -p /tmp/overlay/{lower,upper,work,merged}
echo "base file" > /tmp/overlay/lower/base.txt

# Mount OverlayFS
mount -t overlay overlay -o lowerdir=/tmp/overlay/lower,upperdir=/tmp/overlay/upper,workdir=/tmp/overlay/work /tmp/overlay/merged
```

---

## Summary

OverlayFS presents a unified filesystem view combining read-only image layers (`lowerdir`) and a writable layer (`upperdir`).

---

## Lab Tasks

### Task 1: Explore Container Filesystem Abstractions (`lnx-explore-container-filesystem`)
1. Start the lab:
   ```bash
   tld start lnx-explore-container-filesystem
   ```
2. Create directory `$HOME/container-fs-test`.
3. Inspect container rootfs directory structures (`chroot`, `pivot_root`).
4. Write output summary line `CONTAINER_ROOTFS_EXPLORED` to `$HOME/container-fs-test/rootfs_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate OverlayFS Storage Layers (`lnx-investigate-overlay-filesystem`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-overlay-filesystem
   ```
2. Create directory `$HOME/container-fs-test`.
3. Inspect OverlayFS storage layers (`lowerdir`, `upperdir`, `workdir`, `merged`).
4. Write output line `OVERLAYFS_LAYERS_INVESTIGATED` into `$HOME/container-fs-test/overlay_info.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
