## Request-Response Lifecycle

Every time you visit a website or fetch an API resource, an HTTP transaction takes place. This transaction consists of a **Request** from the client and a **Response** from the server.

---

## 1. Anatomy of an HTTP Request

An HTTP request is a plain-text message sent from a client to a server. It contains three main parts:

### A. Request Line
Specifies the HTTP method, the requested path, and the HTTP protocol version.
- **Method**: The action to perform (e.g., `GET` to retrieve, `POST` to create, `PUT` to update, `DELETE` to remove).
- **URI/Path**: The location of the resource (e.g., `/index.html` or `/api/users`).
- **Version**: E.g., `HTTP/1.1` or `HTTP/2`.

Example:
```http
GET /index.html HTTP/1.1
```

### B. Headers
Key-value pairs providing metadata about the request, such as the host, content-type, or user-agent.
```http
Host: www.example.com
User-Agent: Mozilla/5.0
Accept: text/html
```

### C. Body (Optional)
The payload containing data sent to the server (common in `POST` and `PUT` requests, like JSON or form data).

---

## 2. Anatomy of an HTTP Response

After processing the request, the server returns an HTTP response, which also has three parts:

### A. Status Line
Includes the HTTP version and a status code indicating the outcome of the request.
```http
HTTP/1.1 200 OK
```

Common status codes:
- **1xx (Informational)**: Request received, continuing process.
- **2xx (Success)**: The action was successfully received and accepted (e.g., `200 OK`, `201 Created`).
- **3xx (Redirection)**: Further action needs to be taken (e.g., `301 Moved Permanently`, `302 Found`).
- **4xx (Client Error)**: The request contains bad syntax or cannot be fulfilled (e.g., `400 Bad Request`, `401 Unauthorized`, `404 Not Found`).
- **5xx (Server Error)**: The server failed to fulfill an apparently valid request (e.g., `500 Internal Server Error`, `502 Bad Gateway`, `503 Service Unavailable`).

### B. Headers
Metadata about the response, such as content type, content length, server signature, and caching directives.
```http
Content-Type: text/html; charset=UTF-8
Content-Length: 1254
Server: nginx/1.24.0
```

### C. Body (Optional)
The actual content returned (e.g., HTML markup, JSON payload, or image binary data).

---

## 3. How Nginx Processes Requests

When Nginx receives an HTTP request, it evaluates it against its configuration rules:
1. **IP & Port Binding**: Nginx checks which `listen` directive matches the incoming connection's destination.
2. **Server Block Selection**: Nginx compares the `Host` header of the request with the `server_name` directives to find the correct `server` block.
3. **Location Block Selection**: Within that server block, Nginx compares the request URI with the `location` directives to determine how to serve the resource (e.g., serving static files, proxying to a backend, redirecting, etc.).

---

## Complete the Section

With a firm grasp of HTTP and how Nginx matches requests, you are ready to get hands-on! Proceed to the next section to install Nginx and run your first web server.
