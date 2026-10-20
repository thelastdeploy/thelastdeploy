# Validation and Linting

Before applying configurations, always validate them using built-in commands and linting utilities.

## 1. Validation (`terraform validate`)
This command verifies whether configurations are syntactically valid and internally consistent (e.g., checks arguments, types, and variables).
It requires the project to be initialized (`terraform init`) first.

## 2. Linting (`tflint`)
While validate checks syntax correctness, linting tools analyze best practices, warnings, potential errors, and deprecated providers.

---

## Lab Tasks

### Task 1: Fix HCL Syntax Errors
1. Start the lab in your terminal:
   ```bash
   tld start tf-fix-syntax
   ```
2. Navigate to the challenge directory:
   ```bash
   cd ~/terraform-hcl-challenge
   ```
3. Inspect `main.tf` to identify the missing closing brace `}` on the `local_file` resource block:
   ```bash
   cat main.tf
   ```
4. Fix the syntax error by closing the resource block:
   ```hcl
   provider "local" {}

   resource "local_file" "syntax" {
     content  = "Fix me!"
     filename = "/tmp/syntax.txt"
   }
   ```
5. Initialize and validate the configuration:
   ```bash
   terraform init
   terraform validate
   ```
6. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Validate a Terraform Project
1. Start the lab in your terminal:
   ```bash
   tld start tf-validate-project
   ```
2. Navigate to the challenge directory:
   ```bash
   cd ~/terraform-hcl-challenge
   ```
3. Initialize the workspace to install required provider plugins:
   ```bash
   terraform init
   ```
4. Run validation to verify the project configurations:
   ```bash
   terraform validate
   ```
5. Verify the task:
   ```bash
   tld check
   ```
