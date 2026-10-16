---
name: lab-testing-guide
description: >-
  Standard operating procedure and comprehensive guide for auditing curriculum content,
  resolving validator discrepancies, and authoring end-to-end positive student test journeys
  for The Last Deploy (TLD) labs.
---

# The Last Deploy (TLD) — Lab Testing & Curriculum Verification Guide

This guide defines the standardized methodology for auditing educational content, aligning lab environments, and authoring automated positive test journeys across The Last Deploy curriculum.

---

## 1. Core Principles & Platform Standards

1. **Brand Consistency**:
   - Always use **"The Last Deploy"** or **"TLD"**.
   - Never use "DevLab". Reconcile any legacy occurrences in hostnames (`tld.local`), environment variables (`LAB_ENV="tld"`), or text.
2. **Pedagogical Integrity (Zero Spoilers)**:
   - Eliminate direct copy-paste cheat codes from `content.md` (e.g., remove parenthetical answers like `(chmod +x)`, `(0 2 * * *)`, `(source ...)`, `(e.g., heavy_dump.log)`).
   - Tasks must describe *what* objective to achieve and *why*, guiding the student to solve the problem without giving away the exact shell command.
3. **Strict Positive-Only Test Journeys**:
   - Test flows simulate authentic, successful student terminal sessions.
   - Every intermediate exploration command (`ls`, `cat`, `grep`, `stat`, `id`, `printenv`) must assert its exit code and stdout before running `tld check`.
4. **Section-by-Section Checkpoint Protocol**:
   - Execute strictly section-by-section.
   - Complete content inspection, lab validation, and test authoring for one section, present a structured report, and pause for user confirmation (`"Sure"`) before starting the next section.
5. **Local Dev Environment**:
   - The test runner strictly targets `./bin/tld-dev` and the `~/.tld-dev` configuration directory.
   - Automated runs utilize `TLD_NON_INTERACTIVE=1` to bypass interactive shell attachments.

---

## 2. Phase 1: Curriculum Content Auditing (`content.md`)

Before authoring tests, thoroughly inspect `content.md` and `section.yaml`:

1. **Verify Task Accuracy**:
   - Match task descriptions against `lab.yaml` and `validator.sh`.
   - Ensure target file paths in `content.md` match actual seeded files (e.g., preventing mismatches like `web.conf` vs `service.conf`, or non-existent files like `shadow_copy`).
2. **Explicit Line Formatting Requirements**:
   - If a validator expects specific keys or capitalization (e.g., `USER=`, `UID=`, `GROUPS=`, or `SCENARIO_1: <ALLOWED|DENIED>`), explicitly state the formatting requirement in `content.md` so students do not fail on arbitrary syntax mismatches.
3. **Document Context & Missing References**:
   - If a lab relies on a pre-seeded file (e.g., `$HOME/sec-test/perm_eval.txt` or `$HOME/config-challenge/.env.template`), explicitly mention it in `content.md`.
4. **Remove Answer Spoilers**:
   - Clean up inline spoiler parentheses while preserving clear operational requirements.

---

## 3. Phase 2: Lab Infrastructure & Validator Verification

Inspect each lab's `lab.yaml` and `validator.sh`:

1. **`lab.yaml` Setup & Seed Commands**:
   - Verify environment profile: `profile: tld-ubuntu`.
   - Check `seed_commands` for proper directory creation, file seeding, and correct variable expansion (e.g., unquoted `$HOME` in single-quoted YAML strings so bash expands it properly).
   - Ensure clean initial state (remove stale result files or mock outputs).
2. **`validator.sh` Assertion Logic**:
   - Identify every checked file condition (`-f`, `-d`, `-x`, `-L`).
   - Identify every regex pattern and exact string matching condition.
   - Note case sensitivity: add `-i` flags to `grep` checks when appropriate to prevent brittle student rejections.
   - Support backwards-compatible aliases where appropriate (e.g., `export LAB_ENV=["']?(tld|devlab)["']?`).

---

## 4. Phase 3: Positive Test Journey Authoring

### Directory & File Placement
Test journeys are stored under:
```
tests/labs/<track>/<module>/<section>/<lab_id>/positive/student_<action>.sh
```
*Always mark scripts as executable*: `chmod +x <test_script>.sh`.

### Test Script Anatomy
Every test script follows this structure:

```bash
#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: <Lab Title>
# Module: <module-id>
# Section: <section-id>
# Lab ID: <lab-id>
# ==============================================================================
set -euo pipefail

LAB_ID="<lab-id>"

# Step 1: Student Exploration & Discovery
student_exec "<exploration-command>" \
    --desc "Student inspects initial environment state" \
    --expect-exit 0 \
    --expect-stdout "<expected-key-output>"

# Step 2: Student Execution & Remediation
student_exec "<action-command>" \
    --desc "Student performs required configuration or task" \
    --expect-exit 0

# Step 3: Student Verification
student_exec "<verification-command>" \
    --desc "Student verifies modified state" \
    --expect-exit 0 \
    --expect-stdout "<expected-result>"

# Step 4: Submission & Validation Check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: <Exact validation pass string>"
```

### Essential Rules for Test Journeys
- **Never skip steps**: Do not jump directly to writing the final file without first simulating realistic student exploration (`ls`, `cat`, `head`, `stat`, etc.).
- **Assert intermediate steps**: Use `--expect-exit 0` and `--expect-stdout` on intermediate inspection commands to ensure the environment is sane.
- **Exact Pass String**: The final `tld check` must match the validator's exact output message: `--expect-stdout "PASS: ..."`.

---

## 5. Phase 4: Local Dev CLI & Build System

- **Rebuilding Dev Binary**: Whenever Go source code in `agent/` is modified:
  ```bash
  make build-dev
  ```
  Produces `./bin/tld-dev` linked to `vX.X.X-dev [local dev]` targeting `~/.tld-dev`.
- **Testing Individual Labs**:
  ```bash
  make test-lab ID=<lab-id>
  ```
- **Running Automated Test Suite**:
  ```bash
  make test-labs
  ```

---

## 6. Phase 5: Version Control & Git Hygiene
- **Explicit Instruction Only**: Never commit, push to remote, or run automated test runs/suites unless the user explicitly asks or instructs you to do so. Always audit, diagnose, and present findings first.
- **Conventional Commits**: Format commit messages using standard conventions:
  ```bash
  git commit -m "test(labs): add automated positive test suite and curriculum fixes across modules X-Y"
  ```
- **Remote Push**: Push directly to `dev` branch on `origin`:
  ```bash
  git push origin dev
  ```
- **Clean Working Tree**: Ensure `git status` is clean after pushing.
