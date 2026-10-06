---
title: "tld check"
description: "Run automated solution assertion checks against your active lab."
section: "CLI"
---

`tld check` runs the scenario assertion script (`~/.tld/labs/current/validator.sh`) to evaluate your solution.

## Usage

```bash
tld check
```

## Behavior

* Executes `validator.sh` inside the active lab workspace context.
* Formats step assertion outputs (`CHECK_ID|STATUS|MESSAGE`).
* If all assertions return status 0, posts the completion hash to `POST /api/v1/results/check` to credit your account with XP.
* If any assertion fails, outputs the failing step ID and message without crediting XP.

## Flags

* `--verbose`: Print full script stdout/stderr output during execution.
* `-h, --help`: Display command usage help.