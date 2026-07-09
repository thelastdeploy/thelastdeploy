## TLS and HTTPS

To secure web traffic and protect user privacy, websites encrypt their connection using SSL/TLS. Nginx natively handles TLS handshake decryption (known as **SSL Termination**), serving HTTPS traffic to clients and forwarding plain HTTP traffic to backend application servers.

---

## 1. Configuring SSL/TLS Certificates

To configure HTTPS, you need a public SSL certificate (e.g. `cert.pem` or `fullchain.pem`) and a corresponding private key (e.g. `key.pem` or `privkey.pem`).

```nginx
server {
    listen 443 ssl;
    server_name example.com;

    # SSL Certificate Paths
    ssl_certificate /etc/ssl/certs/example.com.crt;
    ssl_certificate_key /etc/ssl/private/example.com.key;

    # Supported TLS Protocols (TLSv1.2 & TLSv1.3 are recommended)
    ssl_protocols TLSv1.2 TLSv1.3;

    # Secure Ciphers Configuration
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
}
```

- **`listen 443 ssl;`**: Configures Nginx to listen for SSL encrypted traffic on the standard HTTPS port `443`.

---

## Complete the Section

Once you understand the basics of TLS configuration, move to the next section to examine HTTP security hardening headers.
