---
title: "Product Roadmap"
description: "Current development priorities and upcoming architectural milestones for TLD."
section: "Community"
---

## Current Priorities & Roadmap

This document outlines active development goals and target releases for TLD CLI, lab engine, and platform features.

### Phase 1: Core Engine & Docs (Completed)
* Go CLI with local Docker socket orchestration (`tld lab start`, `tld check`).
* FastAPI backend with JWT device authentication flow (`tld login`).
* Decoupled Markdown documentation engine rendering directly from `landing/docs/`.
* Foundation tracks: Linux System Administration, Container Fundamentals, and Docker Networking.

### Phase 2: Orchestration & Multi-Node Labs (In Progress)
* **Local k3s Engine:** Support for single-node and multi-node Kubernetes labs using lightweight k3s containers on local Docker networks.
* **Lab Authoring SDK:** Declarative YAML spec for lab authors to define setup containers, validation scripts, and hints.
* **CLI Offline Mode:** Cached validation scripts so basic labs can run without active backend network connections.

### Phase 3: Advanced Tracks & Cloud Integration (Planned)
* **Cloud Infrastructure Labs:** Disposable Terraform / LocalStack environments for debugging cloud IAM and networking issues locally.
* **Team & Classroom Workspaces:** Organization accounts for managing cohorts and tracking team completion metrics.
* **Interactive Terminal Web UI:** Browser-embedded xterm.js terminal connecting directly to local or cloud-hosted lab instances.