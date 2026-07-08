## How the Web Works

Before configuring Nginx, it is crucial to understand the fundamentals of how clients (like web browsers) and servers communicate across the Internet.

---

## 1. The Client-Server Model

The World Wide Web operates on a **client-server model**:
- **Client**: A device or application (such as a browser, mobile app, or CLI tool like `curl`) that initiates a request for a resource.
- **Server**: A computer connected to the network that listens for incoming client requests, processes them, and returns the requested resources (or an error message).

---

## 2. TCP/IP and Ports

Communication on the web relies on the **TCP/IP** protocol stack:
- **IP Address**: A unique numerical label assigned to each device on a network (like a mailing address).
- **TCP (Transmission Control Protocol)**: Establishes a reliable, ordered, and error-checked connection between the client and the server.
- **Ports**: Numbers (from 0 to 65535) used to direct traffic to specific services running on a host. By convention:
  - **Port 80**: Default port for unencrypted web traffic (HTTP).
  - **Port 443**: Default port for secure, encrypted web traffic (HTTPS).

When you type `http://example.com`, your browser implicitly connects to the IP address of `example.com` on port `80`. For `https://example.com`, it connects on port `443`.

---

## 3. The DNS (Domain Name System)

Computers communicate using IP addresses, but humans prefer domain names (like `google.com`). DNS acts as the "phonebook of the Internet," translating human-readable domains into IP addresses:
1. The client queries a DNS resolver: "What is the IP for `example.com`?"
2. The DNS resolver returns the IP address (e.g., `93.184.216.34`).
3. The client connects directly to that IP address.

---

## Complete the Section

Once you understand the basic client-server infrastructure and domain name resolution, proceed to the next section to explore the details of the HTTP Request-Response lifecycle.
