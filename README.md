<p align="center">
  <img src="https://img.shields.io/badge/license-Apache%202.0-green?style=flat-square" alt="License" />
  <img src="https://img.shields.io/badge/version-v1.1.0-blue?style=flat-square" alt="Version" />
  <img src="https://img.shields.io/badge/built%20in-public-blueviolet?style=flat-square" alt="Built in Public" />
  <img src="https://img.shields.io/github/stars/thelastdeploy/thelastdeploy?style=flat-square" alt="Stars" />
</p>

<h1 align="center">The Last Deploy</h1>

<p align="center">
  <strong>Learn DevOps by fixing real systems — on your own machine.</strong><br/>
  No cloud fees. No fake terminals. No passive videos.
</p>

---

## What is TLD?

**The Last Deploy (TLD)** is an open-source DevOps learning platform built around one core principle: you only truly learn when something is broken and you have to fix it.

Instead of watching videos or copying commands from tutorials, you:

1. **Spin up a local lab** on your actual machine with a single CLI command (`tld start <lab-id>`)
2. **Encounter a deliberately broken system** — misconfigured proxies, crashed containers, state file corruptions, or broken git history
3. **Troubleshoot and fix it** using real terminal tools
4. **Validate your fix** with `tld check` — an automated validator engine that verifies exact system state requirements
5. **Track progress and earn XP** across comprehensive DevOps learning tracks at your own pace

Everything runs locally in isolated sandboxes. No cloud costs. Forever free and open-source.

---

## Monorepo Structure

```
/
├── agent/          # TLD CLI (v1.1.0) — Go client & validator runner
│   ├── cmd/        # Command handlers (sync, start, check, stop, status, doctor, etc.)
│   └── internal/   # Core logic (cache, local server, validator engine)
├── challenges/     # Lab modules and challenge definitions across DevOps domains
├── landing/        # Marketing site & documentation platform — Next.js 15 / Tailwind CSS
│   ├── docs/       # Content pages (Markdown / MDX architecture & guides)
│   └── navigation.yaml # Dynamic documentation navigation configuration
├── web/
│   ├── backend/    # Platform REST API & seeder — Python / FastAPI + Alembic
│   └── frontend/   # User web dashboard & lab progress UI — Next.js 15
├── infra/
│   └── local/      # Local multi-container development environment (Docker Compose)
├── bin/            # Compiled CLI binaries (gitignored)
├── Makefile        # Developer workflow shortcuts & setup scripts
├── SECURITY.md     # Security disclosure policy & contacts
└── LICENSE         # Apache 2.0
```

---

## Getting Started

### Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Go | 1.21+ | Required for CLI build |
| Node.js | 18+ | Required for landing page, docs, & web frontend |
| Python | 3.11+ | Required for backend API |
| Docker | 24+ | Required for running containerized labs |

---

### CLI Quickstart

#### 1 — Build & Install the CLI (`v1.1.0`)

```bash
# Build and install tld binary to /usr/local/bin
make install

# Or build to ./bin/tld locally
make build
```

#### 2 — Authenticate (Optional for local self-hosted use)

```bash
tld login
```

#### 3 — Sync Challenges

Fetch available challenge modules and labs from the platform:

```bash
tld sync --all
```

#### 4 — Start a Lab

```bash
tld start <lab-id>
```

#### 5 — Validate Your Fix

Run the automated validator to verify your solution:

```bash
tld check
```

#### 6 — CLI Command Summary

| Command | Usage | Description |
|---------|-------|-------------|
| `tld sync` | `tld sync --all` | Download and update local lab challenge modules |
| `tld start` | `tld start <lab-id>` | Spin up a local lab environment |
| `tld check` | `tld check` | Run validation scripts against active lab |
| `tld stop` | `tld stop` | Stop active lab environment and server |
| `tld status` | `tld status` | Display authentication state, synced content, & active lab |
| `tld doctor` | `tld doctor` | Run system diagnostics (Docker, Go, permissions) |
| `tld login` | `tld login` | Authenticate CLI with TLD platform |
| `tld logout` | `tld logout` | Remove stored authentication tokens |
| `tld publish` | `tld publish <path>` | Package & publish local challenge module directory |
| `tld version` | `tld version` | Display CLI version information |

---

## Running the Web Application (Local Development)

### ⚡ One-Command Stack Setup (Recommended)

Run the full platform stack locally (PostgreSQL 16, Backend API, Web Dashboard, Landing/Docs, and Seeder) with Docker Compose:

```bash
# Spin up full stack (Postgres + Backend + Web Frontend + Landing + Seeder)
make dev-up

# View live logs across containers
make dev-logs

# Re-run database seeding
make dev-seed

# Stop development containers
make dev-down
```

#### Local Endpoints & Test Accounts:
- **Web Dashboard:** [http://localhost:9000](http://localhost:9000)
- **Backend API & Swagger Docs:** [http://localhost:9001](http://localhost:9001) / [http://localhost:9001/docs](http://localhost:9001/docs)
- **Landing & Documentation Platform:** [http://localhost:9002](http://localhost:9002)
- **Default Seeded Account:** `dev@example.com` / `password123`

---

### Manual Service Execution

If developing individual services outside Docker:

```bash
# Backend API (FastAPI)
cd web/backend
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 9001

# Web Frontend (Next.js)
cd web/frontend
npm install
npm run dev # runs on http://localhost:9000

# Landing & Documentation Platform (Next.js)
cd landing
npm install
npm run dev # runs on http://localhost:9002
```

---

## Tracks & Learning Domains

The Last Deploy provides hands-on challenge modules across key DevOps & Cloud Infrastructure domains:

<!-- TRACKS_START -->
<table width="100%">
<tr>
<td width="50%" valign="top">
  <h4>🐧 Linux Administration</h4>
  <p>System fundamentals, process management, systemd, storage, LVM, networking & incident response.</p>
  <p><sub>📦 Content: <b>34</b> modules &nbsp;|&nbsp; <a href="http://localhost:9002/docs"><img src="https://img.shields.io/badge/Status-Available-brightgreen?style=flat-square" alt="Available" /></a></sub></p>
</td>
<td width="50%" valign="top">
  <h4>🐳 Docker & Containers</h4>
  <p>Container runtime isolation, image optimization, multi-stage builds, networking, storage & Compose.</p>
  <p><sub>📦 Content: <b>7</b> modules &nbsp;|&nbsp; <a href="http://localhost:9002/docs"><img src="https://img.shields.io/badge/Status-Available-brightgreen?style=flat-square" alt="Available" /></a></sub></p>
</td>
</tr>
<tr>
<td width="50%" valign="top">
  <h4>☸️ Kubernetes & Cloud Native</h4>
  <p>Pod debugging, service routing, ConfigMaps, volume storage, workloads & cluster troubleshooting.</p>
  <p><sub>📦 Content: <b>6</b> modules &nbsp;|&nbsp; <a href="http://localhost:9002/docs"><img src="https://img.shields.io/badge/Status-Available-brightgreen?style=flat-square" alt="Available" /></a></sub></p>
</td>
<td width="50%" valign="top">
  <h4>🌐 Nginx & Web Servers</h4>
  <p>Reverse proxying, load balancing, TLS configuration, rate limiting, location routing & security.</p>
  <p><sub>📦 Content: <b>7</b> modules &nbsp;|&nbsp; <a href="http://localhost:9002/docs"><img src="https://img.shields.io/badge/Status-Available-brightgreen?style=flat-square" alt="Available" /></a></sub></p>
</td>
</tr>
<tr>
<td width="50%" valign="top">
  <h4>🏗️ Terraform & IaC</h4>
  <p>HCL syntax, state management, module architecture, variable scoping & infrastructure drift.</p>
  <p><sub>📦 Content: <b>7</b> modules &nbsp;|&nbsp; <a href="http://localhost:9002/docs"><img src="https://img.shields.io/badge/Status-Available-brightgreen?style=flat-square" alt="Available" /></a></sub></p>
</td>
<td width="50%" valign="top">
  <h4>🔀 Git & Version Control</h4>
  <p>Advanced workflows, rebase conflicts, detached HEADs, reflog recovery & history rewrites.</p>
  <p><sub>📦 Content: <b>5</b> modules &nbsp;|&nbsp; <a href="http://localhost:9002/docs"><img src="https://img.shields.io/badge/Status-Available-brightgreen?style=flat-square" alt="Available" /></a></sub></p>
</td>
</tr>
<tr>
<td width="50%" valign="top">
  <h4>🔄 CI/CD Pipelines</h4>
  <p>Automated build pipelines, secret management, test integration & artifact deployment.</p>
  <p><sub>📦 Content: <i>Upcoming</i> &nbsp;|&nbsp; <img src="https://img.shields.io/badge/Status-Coming%20Soon-orange?style=flat-square" alt="Coming Soon" /></sub></p>
</td>
<td width="50%" valign="top">
  <h4>📊 Observability & Monitoring</h4>
  <p>Metrics collection, Prometheus queries, Grafana dashboards, log aggregation & alerting.</p>
  <p><sub>📦 Content: <i>Upcoming</i> &nbsp;|&nbsp; <img src="https://img.shields.io/badge/Status-Coming%20Soon-orange?style=flat-square" alt="Coming Soon" /></sub></p>
</td>
</tr>
</table>
<!-- TRACKS_END -->

> 💡 **Live Catalog & Details**: Available labs and track modules expand continuously as new challenges are added. Run `tld sync --all` to retrieve the latest content locally, or explore the live documentation catalog at [http://localhost:9002/docs](http://localhost:9002/docs).


---

## Contributing

We welcome contributions! Whether you are adding new lab challenges, improving validator checks, enhancing documentation, or fixing bugs:

- Check out [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution guidelines and module creation guides.
- Open an issue or pull request to start a discussion.

---

## Security

Security vulnerabilities should be reported directly to **`security@thelastdeploy.com`**.
Please refer to our [SECURITY.md](./SECURITY.md) policy for response timelines and disclosure guidelines.

---

## Community & Support

- 💬 **Discord** — [Join our Discord community](https://discord.gg/tgShvdV8f)
- ⭐ **GitHub** — Star the repository on [GitHub](https://github.com/thelastdeploy/thelastdeploy)
- 🔧 **Issues** — [Open an issue](https://github.com/thelastdeploy/thelastdeploy/issues) for bug reports or feature requests

---

## License

Licensed under the **Apache License 2.0**. See [LICENSE](./LICENSE) for details.

Copyright 2026 Shreyansh Shankar
