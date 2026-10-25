# Module Errors

Module errors happen when:
- The `source` directory or URL cannot be resolved.
- A required input variable is missing in the `module` invocation block.
- Module outputs referenced in root configurations are named incorrectly.

Always run `terraform init` after modifying module sources or paths.

---

## Lab Tasks

### Task 1: Fix Module Invocation Errors
1. Start the lab in your terminal:
   ```bash
   tld start tf-fix-module
   ```
2. Navigate to `~/terraform-troubleshoot-challenge`:
   ```bash
   cd ~/terraform-troubleshoot-challenge
   ```
3. Open `main.tf` and pass the required `val` argument to the `module "sub_call"` block:
   ```hcl
   module "sub_call" {
     source = "./modules/sub"
     val    = "hello"
   }
   ```
4. Validate the configuration using `terraform validate`:
   ```bash
   terraform validate
   ```
5. Verify the task:
   ```bash
   tld check
   ```
