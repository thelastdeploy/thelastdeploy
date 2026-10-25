# Recover from State Drift

In this exercise, you will diagnose and repair infrastructure that has drifted or suffered accidental file deletion, bringing state and real-world files back into alignment.

---

## Lab Tasks

### Task 1: Reconcile Drifting Infrastructure
1. Start the lab in your terminal:
   ```bash
   tld start tf-fix-state
   ```
2. Navigate to `~/terraform-state-challenge`:
   ```bash
   cd ~/terraform-state-challenge
   ```
3. Reconcile the drifted infrastructure and recreate `/tmp/recovery.txt` by running:
   ```bash
   terraform apply -auto-approve
   ```
4. Verify the task:
   ```bash
   tld check
   ```
