# Linux Network Namespaces & Isolation

Network namespaces are a fundamental Linux kernel feature that provides isolated virtual network stacks—including dedicated network interfaces, IP addresses, routing tables, socket lookup tables, ARP tables, and firewall rules. Network namespaces form the underlying networking isolation primitive used by container engines like Docker and Kubernetes CNI plugins.

---

## 1. Creating and Managing Network Namespaces

The `ip netns` command utility manages network namespaces in Linux:

```bash
# Create a new network namespace named 'ns-app'
ip netns add ns-app

# List all active network namespaces on the host
ip netns list

# Execute a command inside a specific network namespace
ip netns exec ns-app ip addr show

# Enter an interactive bash shell inside a network namespace
ip netns exec ns-app bash

# Delete a network namespace
ip netns delete ns-app
```

---

## 2. Connecting Namespaces with `veth` Pairs

A Virtual Ethernet (`veth`) pair acts like a virtual patch cable connecting two network interfaces across namespace boundaries:

```bash
# Create a veth pair named 'veth-host' and 'veth-ns'
ip link add veth-host type veth peer name veth-ns

# Move one end of the pair into 'ns-app' namespace
ip link set veth-ns netns ns-app

# Configure host side interface
ip addr add 10.200.1.1/24 dev veth-host
ip link set veth-host up

# Configure namespace side interface
ip netns exec ns-app ip addr add 10.200.1.2/24 dev veth-ns
ip netns exec ns-app ip link set veth-ns up
ip netns exec ns-app ip link set lo up

# Test ping connectivity from host to namespace
ping -c 2 10.200.1.2
```

---

## Summary

Network namespaces provide isolated network stacks, connected to the host or other namespaces using `veth` virtual interface pairs.

---

## Lab Tasks

### Task 1: Create and Inspect Network Namespace (`lnx-create-network-namespace`)
1. Start the lab:
   ```bash
   tld start lnx-create-network-namespace
   ```
2. Create directory `$HOME/netns-test` and inspect network namespaces:
   ```bash
   mkdir -p "$HOME/netns-test"
   ip netns list
   ```
3. Record the inspection marker into `$HOME/netns-test/ns_list.txt`:
   ```bash
   echo "NETNS_INSPECTED" > "$HOME/netns-test/ns_list.txt"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Connect Network Namespaces with veth Pairs (`lnx-connect-network-namespaces`)
1. Start the lab:
   ```bash
   tld start lnx-connect-network-namespaces
   ```
2. Create directory `$HOME/netns-test`:
   ```bash
   mkdir -p "$HOME/netns-test"
   ```
3. Create the veth connection script `$HOME/netns-test/connect_ns.sh`:
   ```bash
   cat << 'EOF' > "$HOME/netns-test/connect_ns.sh"
   #!/usr/bin/env bash
   ip netns add ns-demo
   ip link add veth-h type veth peer name veth-n
   ip link set veth-n netns ns-demo
   EOF
   chmod +x "$HOME/netns-test/connect_ns.sh"
   ```
4. Write summary line `VETH_PAIR_CONFIGURED` to `$HOME/netns-test/veth_summary.txt`:
   ```bash
   echo "VETH_PAIR_CONFIGURED" > "$HOME/netns-test/veth_summary.txt"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
