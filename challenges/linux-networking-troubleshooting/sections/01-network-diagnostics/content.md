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
