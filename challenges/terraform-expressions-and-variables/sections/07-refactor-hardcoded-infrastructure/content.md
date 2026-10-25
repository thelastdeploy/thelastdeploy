# Refactor Hardcoded Infrastructure

Hardcoded values make Terraform configurations rigid, difficult to maintain, and prone to duplication bugs.

In this section, you will identify hardcoded values in a legacy configuration and refactor them using variables, local values, and functions to create a clean, DRY project structure.

---

## Lab Tasks

### Task 1: Refactor Hardcoded Configuration
1. Start the lab in your terminal:
   ```bash
   tld start tf-remove-hardcoding
   ```
2. Navigate to `~/terraform-expr-challenge`:
   ```bash
   cd ~/terraform-expr-challenge
   ```
3. Open `main.tf` and refactor the hardcoded string `"hardcoded_value_123"` using a variable:
   ```hcl
   variable "file_content" {
     type    = string
     default = "dynamic_value_123"
   }

   resource "local_file" "f1" {
     content  = var.file_content
     filename = "/tmp/hardcoded.txt"
   }
   ```
4. Initialize the workspace and validate the configuration:
   ```bash
   terraform init
   terraform validate
   ```
5. Verify the task:
   ```bash
   tld check
   ```
