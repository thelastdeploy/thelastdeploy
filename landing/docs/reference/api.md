---
title: "REST API Endpoint Reference"
description: "HTTP endpoints exposed by the TLD FastAPI backend service."
section: "Reference"
---

## Overview

The TLD Backend service exposes HTTP endpoints under `/api/v1/`. The API handles authentication, user profile management, lab registry discovery, and validation submission processing.

Base URL in local dev: `http://localhost:9001/api/v1`

---

## Authentication Endpoints (`/api/v1/auth`)

### Initiate Device Authorization Flow
```http
POST /api/v1/auth/cli/device-code
```
Initiates terminal OAuth2 device flow (RFC 8628). Returns a user code, device code, verification URL, and expiration window.

* **Request Body:** None
* **Response (200 OK):**
```json
{
  "device_code": "dev_8f3a9b21c4e7",
  "user_code": "TLD-9482",
  "verification_uri": "http://localhost:9000/cli-login",
  "expires_in": 900,
  "interval": 5
}
```

### Exchange Device Code for Token
```http
POST /api/v1/auth/cli/token
```
Polled by `tld login` while waiting for user confirmation on the web app.

* **Request Body:**
```json
{
  "device_code": "dev_8f3a9b21c4e7"
}
```
* **Response (200 OK - Pending):**
```json
{
  "status": "pending"
}
```
* **Response (200 OK - Authorized):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1Ni...",
  "token_type": "bearer",
  "user": {
    "id": "usr_10293",
    "username": "sysadmin"
  }
}
```

---

## Lab Registry Endpoints (`/api/v1/modules`)

### List Available Curriculum Modules
```http
GET /api/v1/modules
```
Returns all active modules and included labs.

* **Response (200 OK):**
```json
[
  {
    "id": "linux-fundamentals",
    "title": "Linux Fundamentals",
    "topic": "linux",
    "lab_count": 5
  }
]
```

### Get Detailed Lab Specs
```http
GET /api/v1/labs/{lab_id}
```
Fetches lab configuration, container image name, resource limits, and instructions.

* **Response (200 OK):**
```json
{
  "id": "linux-file-permissions",
  "title": "Fix Broken File Permissions",
  "image": "tld/lab-linux-file-permissions:latest",
  "environment": {
    "PORT": "8080"
  },
  "xp": 50
}
```

---

## Validation & Results (`/api/v1/results`)

### Submit Solution Verification
```http
POST /api/v1/results/check
```
Submits verification script stdout/stderr logs and pass status from `tld check`.

* **Headers:** `Authorization: Bearer <access_token>`
* **Request Body:**
```json
{
  "lab_id": "linux-file-permissions",
  "passed": true,
  "execution_time_ms": 420,
  "logs": "PASS: file mode 0644 verified on /var/www/html/index.html"
}
```
* **Response (200 OK):**
```json
{
  "status": "recorded",
  "xp_awarded": 50,
  "total_xp": 350
}
```