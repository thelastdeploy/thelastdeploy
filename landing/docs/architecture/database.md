---
title: "Database Schema & Models"
description: "Entity Relationship Diagram, table schemas, indexes, and relations in PostgreSQL 16."
section: "Architecture"
---

TLD uses PostgreSQL 16 Alpine as its primary datastore. Database tables are defined in `web/backend/app/models.py` using SQLAlchemy 2.0 Mapped columns.

## Database Schema Diagram

```
┌──────────────────────────┐             ┌──────────────────────────┐
│          users           │             │     cli_device_auths     │
├──────────────────────────┤             ├──────────────────────────┤
│ id (PK)                 │ 1         * │ id (PK)                  │
│ username (UQ)            │ ─────────── │ user_id (FK)             │
│ email (UQ)               │             │ device_code (UQ, IDX)    │
│ password_hash            │             │ user_code (UQ, IDX)      │
│ xp                       │             │ status                   │
│ streak_days              │             │ expires_at               │
└──────────┬───────────────┘             └──────────────────────────┘
           │ 1
           │
           │ *
┌──────────┴───────────────┐             ┌──────────────────────────┐
│       lab_progress       │ *         1 │           labs           │
├──────────────────────────┤             ├──────────────────────────┤
│ id (PK)                  │ ─────────── │ id (PK, String)          │
│ user_id (FK, IDX)        │             │ module_id (FK)           │
│ lab_id (FK, IDX)         │             │ section_id (FK)          │
│ completed (Bool)         │             │ title                    │
│ xp_awarded               │             │ xp                       │
│ completed_at             │             │ validator_script         │
└──────────────────────────┘             └─────────────▲────────────┘
                                                       │ *
                                                       │ 1
┌──────────────────────────┐             ┌─────────────┴────────────┐
│         modules          │ 1         * │         sections         │
├──────────────────────────┤             ├──────────────────────────┤
│ id (PK, String)          │ ─────────── │ id (PK, String)          │
│ title                    │             │ module_id (FK)           │
│ topic                    │             │ title                    │
│ difficulty               │             │ order                    │
│ total_xp                 │             │ xp                       │
└──────────────────────────┘             └──────────────────────────┘
```

## Table Specifications

### 1. `users`
* `id`: Integer, Primary Key, Autoincrement.
* `username`: String(50), Unique, Indexed.
* `email`: String(255), Unique, Indexed.
* `password_hash`: String(255), bcrypt hash.
* `xp`: Integer, Default: 0 (Total verified XP).
* `streak_days`: Integer, Default: 0 (Daily consecutive activity).
* `is_maintainer`: Boolean, Default: false (Grants module builder access).
* `device_key`: String(64), Unique, Nullable (Paired CLI hardware key).

### 2. `cli_device_auths`
* `id`: Integer, Primary Key.
* `device_code`: String(64), Unique, Indexed.
* `user_code`: String(20), Unique, Indexed (8-character code entered in browser).
* `user_id`: Integer, Foreign Key -> `users.id`, Nullable.
* `status`: String(20), Default: `"pending"` (`pending`, `authorized`, `expired`).
* `expires_at`: DateTime (timezone aware).

### 3. `modules`, `sections`, `labs`
* **`modules`**: `id` (String 100, PK, e.g. `"linux-fundamentals"`), `title`, `description`, `topic`, `difficulty`, `estimated_minutes`, `total_xp`, `total_sections`.
* **`sections`**: `id` (String 100, PK), `module_id` (FK -> `modules.id`), `title`, `order`, `xp`, `content`.
* **`labs`**: `id` (String 100, PK, e.g. `"lnx-file-permissions"`), `module_id` (FK), `section_id` (FK), `title`, `xp`, `validator_script`.

### 4. `lab_progress` & `section_progress`
* **`lab_progress`**: Tracks lab completion via `tld check`. Foreign keys to `users.id` and `labs.id`, storing `completed` boolean, `xp_awarded`, and `completed_at` timestamp.
* **`section_progress`**: Tracks reading section completion triggered by reading scroll position.