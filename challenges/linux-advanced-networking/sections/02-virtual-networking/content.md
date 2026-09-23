# Virtual Networking & Linux Bridges

A Linux network bridge operates as a virtual Layer 2 Ethernet switch inside the Linux kernel. Bridges connect multiple physical or virtual network interfaces (`veth`, `TAP`, `dummy`) together into a single broadcast domain.

---

## 1. Creating and Managing Linux Bridges

Using `ip link` to manage Linux software bridges:

```bash
# Create a new bridge interface named 'br0'
ip link add br0 type bridge

# Bring up the bridge interface
ip link set br0 up

# Assign an IP address to the bridge (acting as default gateway for attached endpoints)
ip addr add 172.20.0.1/16 dev br0

# Attach interface 'veth-host' to bridge 'br0'
ip link set veth-host master br0

# View attached bridge ports and bridge details
ip link show master br0
bridge link show
```

---

## 2. Virtual Interface Types

- **`veth`**: Virtual ethernet pair acting as a virtual cable.
- **`bridge`**: Software switch connecting multiple interfaces.
- **`dummy`**: Virtual loopback-like interface used to host IP addresses without physical link dependencies.
- **`TAP/TUN`**: Userspace virtual network devices used by VPNs and virtual machine hypervisors (QEMU/KVM).

---

## Summary

Linux bridges multiplex network connectivity between host environments, containers, and virtual machines at Layer 2.

---

## Lab Tasks

### Task 1: Build Linux Network Bridge (`lnx-build-linux-network-bridge`)
1. Start the lab:
   ```bash
   tld start lnx-build-linux-network-bridge
   ```
2. Create directory `$HOME/vnet-test`.
3. Write bridge creation and attachment commands into `$HOME/vnet-test/bridge_setup.sh` (`ip link add br-test type bridge`, `ip link set br-test up`).
4. Write summary `BRIDGE_CREATED: br-test` into `$HOME/vnet-test/bridge_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Create Virtual Network Interfaces (`lnx-create-virtual-network-interface`)
1. Start the lab:
   ```bash
   tld start lnx-create-virtual-network-interface
   ```
2. Create directory `$HOME/vnet-test`.
3. Document virtual interface creation syntax (`ip link add dummy0 type dummy`).
4. Write output `DUMMY_INTERFACE_VERIFIED` to `$HOME/vnet-test/vif_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
