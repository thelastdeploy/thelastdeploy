---
title: "DevOps Networking Essentials"
description: "TCP/IP layer fundamentals, DNS resolution mechanics, HTTP status protocol, and Linux firewalls."
section: "Learn"
---

## OSI & TCP/IP Layer Model

DevOps engineers troubleshoot issues across multiple network layers:

| Layer | Protocol Examples | Common Diagnostic Tools |
| :--- | :--- | :--- |
| **Layer 7 (Application)** | HTTP, HTTPS, SSH, DNS | `curl`, `dig`, `nslookup` |
| **Layer 4 (Transport)** | TCP, UDP | `netstat`, `ss`, `nc` (netcat), `nmap` |
| **Layer 3 (Network)** | IP, ICMP | `ping`, `traceroute`, `ip route` |
| **Layer 2 (Data Link)** | Ethernet, ARP | `ip link`, `arp`, `tcpdump` |

---

## DNS Resolution Flow

When a service makes a request to `api.thelastdeploy.com`:

1. Local resolver checks `/etc/hosts` and `/etc/resolv.conf`.
2. Resolving server queries DNS hierarchy: Root (`.`) -> TLD (`.com`) -> Authoritative nameserver.
3. IP address (`192.0.2.1`) is returned and cached locally.

### Inspecting DNS with `dig`
```bash
dig +short api.thelastdeploy.com
```
Returns raw IP record. Use `dig +trace` to inspect full hierarchical DNS resolution path.

---

## HTTP Protocol & Status Codes

HTTP requests consist of a method (`GET`, `POST`, `PUT`, `DELETE`), headers, path, and optional body.

### Common Status Ranges
* **`2xx` (Success):** `200 OK`, `201 Created`, `204 No Content`.
* **`3xx` (Redirection):** `301 Moved Permanently`, `302 Found`.
* **`4xx` (Client Error):** `400 Bad Request`, `401 Unauthorized`, `403 Forbidden`, `404 Not Found`.
* **`5xx` (Server Error):** `500 Internal Server Error`, `502 Bad Gateway`, `503 Service Unavailable`, `504 Gateway Timeout`.

---

## Linux Socket Inspection

To inspect listening network ports on a host or container:

```bash
# Display listening TCP ports with process names
ss -tulpn
```

* `-t`: Display TCP sockets.
* `-u`: Display UDP sockets.
* `-l`: Show listening sockets only.
* `-p`: Show process name and PID owning socket.
* `-n`: Output numeric ports and IP addresses instead of resolving service names.