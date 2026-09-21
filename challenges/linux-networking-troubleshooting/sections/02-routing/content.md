# Section 02 — Routing

Linux kernel routing tables determine how outgoing IP packets are forwarded based on destination subnet criteria.

## Routing Tools

- `ip route`: Display and modify kernel IPv4 routing table entries.
- `route -n`: Legacy utility showing numerical IP routing tables.
- `ip route get <destination-ip>`: Perform a dry-run lookup to determine which egress interface and gateway IP will be used to reach a specific destination.

## Key Concepts

- **Default Gateway**: The `default via <gateway-ip> dev <interface>` entry handles all traffic without specific subnet matches.
- **Directly Connected Subnets**: Routes automatically generated when an IP address and netmask are assigned to an active interface.
