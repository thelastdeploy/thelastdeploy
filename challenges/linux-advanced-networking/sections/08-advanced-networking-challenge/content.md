# Isolated Multi-Namespace Network Challenge

In this capstone challenge, you will design and construct a fully isolated Linux network topology consisting of multiple network namespaces connected via a software bridge, with configured routing and restrictive packet filtering.

---

## Topology Architecture

```text
+-------------------------------------------------------------+
| Linux Host                                                  |
|                                                             |
|   +-----------------------+     +-----------------------+   |
|   | Namespace: ns-web     |     | Namespace: ns-db      |   |
|   | IP: 10.10.0.10/24     |     | IP: 10.10.0.20/24     |   |
|   | Interface: veth-web   |     | Interface: veth-db    |   |
|   +-----------+-----------+     +-----------+-----------+   |
|               |                             |               |
|               +--------------+--------------+               |
|                              |                              |
|                     +--------+--------+                     |
|                     | Bridge: br-prod |                     |
|                     | IP: 10.10.0.1   |                     |
|                     +-----------------+                     |
+-------------------------------------------------------------+
```

---

## Lab Tasks

### Task 1: Build Isolated Linux Network Topology Capstone (`lnx-build-isolated-linux-network`)
1. Start the lab:
   ```bash
   tld start lnx-build-isolated-linux-network
   ```
2. Create directory `$HOME/net-challenge`:
   ```bash
   mkdir -p "$HOME/net-challenge"
   ```
3. Author the isolated network topology configuration script `$HOME/net-challenge/setup_topology.sh`:
   ```bash
   cat << 'EOF' > "$HOME/net-challenge/setup_topology.sh"
   #!/usr/bin/env bash
   # Create bridge
   ip link add br-prod type bridge
   ip link set br-prod up
   ip addr add 10.10.0.1/24 dev br-prod

   # Create namespaces
   ip netns add ns-web
   ip netns add ns-db

   # Create veth pairs and attach
   ip link add veth-web type veth peer name veth-web-br
   ip link set veth-web netns ns-web
   ip link set veth-web-br master br-prod
   ip link set veth-web-br up

   ip link add veth-db type veth peer name veth-db-br
   ip link set veth-db netns ns-db
   ip link set veth-db-br master br-prod
   ip link set veth-db-br up
   EOF
   chmod +x "$HOME/net-challenge/setup_topology.sh"
   ```
4. Record the topology build completion marker into `$HOME/net-challenge/topology.log`:
   ```bash
   echo "TOPOLOGY_BUILD_COMPLETE" > "$HOME/net-challenge/topology.log"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
