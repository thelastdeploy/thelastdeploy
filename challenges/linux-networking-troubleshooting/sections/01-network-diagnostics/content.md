# Section 01 — Network Diagnostics

Before diagnosing complex network failures, you must understand how Linux represents network interfaces, IP addresses, and layer 3 connectivity.

## Key Inspection Tools

- `ip link`: List all physical and virtual network interfaces and their link operational state (UP/DOWN).
- `ip addr` / `ip a`: Display IPv4/IPv6 addresses assigned to interfaces.
- `ping -c 4 <host>`: Test ICMP reachability to a remote host.
- `traceroute <host>` / `tracepath <host>`: Track the network path and hop delays across intermediate routers.

## Network Interface States

Network interfaces can exist in several states:
- **UP**: The interface is active and capable of sending/receiving traffic.
- **DOWN**: The interface is disabled administratively or lacks a link carrier.
- **LOOPBACK (`lo`)**: Internal virtual interface (`127.0.0.1`) used for local host communications.

---

## Lab Tasks

### Task 1: Inspect Network State (`lnx-inspect-network-state`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-network-state
   ```
2. Inspect local network interfaces using `ip addr` or `ip link`.
3. Locate the loopback interface (`lo`) and identify its IPv4 address (`127.0.0.1`).
4. Write the loopback IP address into `$HOME/net-test/loopback.txt`:
   ```bash
   mkdir -p "$HOME/net-test"
   echo "127.0.0.1" > "$HOME/net-test/loopback.txt"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Map Network Path (`lnx-map-network-path`)
1. Start the lab:
   ```bash
   tld start lnx-map-network-path
   ```
2. Inspect the simulated network trace output:
   ```bash
   cat "$HOME/net-test/traceroute_sim/path.log"
   ```
3. Identify the target IP address located at hop 4 (`10.20.30.40`).
4. Write the target IP address into `$HOME/net-test/target_hop.txt`:
   ```bash
   mkdir -p "$HOME/net-test"
   echo "10.20.30.40" > "$HOME/net-test/target_hop.txt"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
