# Repair a Broken Configuration

Debugging invalid HCL requires reading validation logs, checking brackets, locating missing `=` assignment signs, and referencing correct labels.

Common syntax errors include:
- Missing commas or braces.
- Incompatible block arguments.
- Typographical mistakes in labels.

---

## Lab Tasks

### Task 1: Debug Invalid HCL Configuration
1. Start the lab in your terminal:
   ```bash
   tld start tf-debug-invalid-hcl
   ```
2. Navigate to the challenge directory:
   ```bash
   cd ~/terraform-hcl-challenge
   ```
3. Inspect `main.tf` to find the missing assignment operator (`=`) on the `filename` argument:
   ```bash
   cat main.tf
   ```
4. Fix the syntax error by updating the argument to `filename = "/tmp/broken.txt"`:
   ```hcl
   provider "local" {}

   resource "local_file" "broken" {
     content  = "Debugging exercise"
     filename = "/tmp/broken.txt"
   }
   ```
5. Initialize the workspace and validate the configuration:
   ```bash
   terraform init
   terraform validate
   ```
6. Verify the task:
   ```bash
   tld check
   ```
