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
2. Create directory `$HOME/net-challenge`.
3. Write script `$HOME/net-challenge/setup_topology.sh` configuring an isolated network topology with two namespaces (`ns-web` and `ns-db`) connected via bridge `br-prod`.
4. Write verification summary line `TOPOLOGY_BUILD_COMPLETE` to `$HOME/net-challenge/topology.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
