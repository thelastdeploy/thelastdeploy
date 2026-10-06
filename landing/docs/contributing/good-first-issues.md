---
title: "Good First Issues & Challenge Authoring"
description: "Finding beginner issues and authoring new challenge modules in /challenges."
section: "Contributing"
---

## Finding Good First Issues

Look for issues on GitHub tagged:
* `good-first-issue`: Ideal for first-time contributors.
* `documentation`: Improving Markdown documentation files.
* `new-lab`: Authoring new challenge scenarios in `/challenges`.

## Authoring a New Challenge Module

To create a new challenge module:

1. Create a directory in `challenges/<module-id>/`.
2. Define `module.yaml` with title, topic, difficulty, and section lists.
3. Add section directories (`sections/01-name/section.yaml`, `content.md`).
4. Create lab directories containing `lab.yaml` and `validator.sh`.
5. Validate using `tld publish` or `make verify`.