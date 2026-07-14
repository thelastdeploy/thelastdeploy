# The Terraform Workflow

The standard Terraform workflow consists of three primary steps:
1. **Write:** Write configurations in HCL files (e.g. `main.tf`).
2. **Init:** Run `terraform init` to download provider plugins and initialize state storage.
3. **Validate & Format:** 
   - `terraform fmt`: Rewrites configurations to a canonical format and style.
   - `terraform validate`: Verifies whether the syntax and arguments of the configurations are valid.

Maintaining formatted and validated files is key to ensuring configurations apply successfully.
