## Reading Access Logs

Nginx records details about all client requests in the **access log**. By default on Linux, this is located at `/var/log/nginx/access.log`. Analyzing this log allows you to monitor traffic patterns, trace API requests, and identify clients making unusual requests.

---

## 1. Log Format Structure

A standard access log entry follows the Combined Log Format:

```text
192.168.1.100 - - [10/Jul/2026:22:15:30 +0000] "GET /api/v1/users HTTP/1.1" 200 612 "-" "Mozilla/5.0"
```

- **`192.168.1.100`**: Client IP address.
- **`[10/Jul/2026...]`**: Time of the request.
- **`"GET /api/v1/users HTTP/1.1"`**: Request method, URI, and HTTP protocol.
- **`200`**: HTTP status code returned to the client.
- **`612`**: Bytes sent to the client (excluding headers).
- **`"-"`**: Referrer header (where the user came from).
- **`"Mozilla/5.0"`**: Client User-Agent string.

---

## 2. Analyzing Logs with CLI Tools

You can use standard Linux text-processing commands to query Nginx logs:
- **Filter by string (grep)**:
  ```bash
  grep "SecretAgent" /var/log/nginx/access.log
  ```
- **Extract specific fields (awk)**:
  ```bash
  # Prints the first column (IP addresses)
  awk '{print $1}' /var/log/nginx/access.log
  ```

---

## Lab Tasks

### Task 1: Find client request by User-Agent
1. Start the lab:
   ```bash
   tld start nginx-find-client-request
   ```
2. Search the Nginx access log file `/var/log/nginx/access.log` to find the request that was made using the User-Agent `SecretAgent`.
3. Extract the client's IP address from that request line and write it into a file named `/tmp/client_ip.txt`.
4. Verify the task:
   ```bash
   tld check
   ```
