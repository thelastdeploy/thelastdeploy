# The Terraform Workflow

The standard Terraform workflow consists of three primary steps:
1. **Write:** Write configurations in HCL files (e.g. `main.tf`).
2. **Init:** Run `terraform init` to download provider plugins and initialize state storage.
3. **Validate & Format:** 
   - `terraform fmt`: Rewrites configurations to a canonical format and style.
   - `terraform validate`: Verifies whether the syntax and arguments of the configurations are valid.

Maintaining formatted and validated files is key to ensuring configurations apply successfully.

---

## Lab Tasks

### Task 1: Initialize, Validate, and Format
1. Start the lab in your terminal:
   ```bash
   tld start tf-init-validate-format
   ```
2. Navigate to the project directory:
   ```bash
   cd ~/terraform-challenge
   ```
3. Initialize the workspace to install the provider plugin:
   ```bash
   terraform init
   ```
4. Format the configuration files to canonical HCL style:
   ```bash
   terraform fmt
   ```
5. Validate the configuration syntax and structure:
   ```bash
   terraform validate
   ```
6. Verify the task:
   ```bash
   tld check
   ```
