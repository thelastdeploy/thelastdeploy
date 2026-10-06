---
title: "GitHub Repository"
description: "Repository structure, issue tracking, and repository workflows."
section: "Community"
---

## Repositories & Structure

TLD is developed as an open source monorepo on GitHub.

* **Repository:** [github.com/thelastdeploy/thelastdeploy](https://github.com/thelastdeploy/thelastdeploy)

### Key Directories in `main`

```text
thelastdeploy/
├── cli/              # Go source code for `tld` binary
├── web/
│   ├── backend/      # FastAPI API service & lab validation engine
│   └── frontend/     # Next.js web application & user dashboard
├── landing/          # Documentation site and landing page
└── infra/            # Local Docker Compose setup & infrastructure configs
```

## How We Use GitHub

* **Issues:** Track bug reports, CLI fixes, and specific lab validation errors.
* **Discussions:** Used for broader RFCs, proposals for new learning tracks, and community questions.
* **Pull Requests:** All code and documentation changes undergo code review before merging into `main`.
* **Actions:** CI workflows run `go test ./...`, Python `pytest`, and Next.js build validation on every PR.