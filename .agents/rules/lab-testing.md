# Lab Testing and Curriculum Audit Rules

Whenever auditing curriculum sections or authoring lab test flows for The Last Deploy (TLD):

1. **Protocol Execution**:
   - Work strictly **section-by-section**.
   - For each section:
     1. Audit `content.md`: Reconcile task instructions with `lab.yaml` and `validator.sh`. Eliminate answer spoilers in parentheses. Enforce project name "The Last Deploy" / "TLD" (never "DevLab").
     2. Inspect `lab.yaml` and `validator.sh`: Verify seed commands, environment profiles, and exact validator assertions. Harden validators with case-tolerance when appropriate.
     3. Author positive-only test journeys under `tests/labs/<track>/<module>/<section>/<lab_id>/positive/student_<action>.sh` simulating discovery, action, self-verification, and `tld check`. Always mark `chmod +x`.
     4. Present a detailed progress report and pause for user confirmation (`"Sure"`) before starting the next section.

2. **Environment & Testing Targets**:
   - The CLI binary under test is `./bin/tld-dev`.
   - The configuration directory is `~/.tld-dev`.
   - Never run unprompted full test suites.
