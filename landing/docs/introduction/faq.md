---
title: "Frequently Asked Questions (FAQ)"
description: "Answers to technical and operational questions about TLD."
section: "Introduction"
---

## General

### Is TLD open-source?
Yes, TLD is licensed under Apache 2.0. The CLI, backend, web apps, and challenge definitions are open source.

### Do I need a cloud account?
No. All labs run in local Docker containers on your machine.

### What platforms are supported?
Linux (Ubuntu, Debian, Fedora, Arch) and macOS (Intel and Apple Silicon). Windows is supported via WSL2.

## CLI & Execution

### Do I need an account to use TLD?
No. You can run `tld lab start` and `tld check` anonymously. Account login (`tld login`) is only needed to track progress across machines and save XP.

### How do I reset a lab if I break it completely?
Run `tld lab stop` followed by `tld lab start <id>`. This destroys old containers and provisions a fresh environment.