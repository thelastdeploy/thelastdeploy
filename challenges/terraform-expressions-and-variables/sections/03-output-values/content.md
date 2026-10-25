# Output Values

Output values expose information about infrastructure on the CLI after applying changes, and pass data to other modules or external automation tools.

## Output Syntax:
```hcl
output "file_id" {
  value       = local_file.welcome.id
  description = "The ID generated for the local file resource"
}
```

## Sensitive Outputs
If an output contains sensitive data (like passwords or API tokens), set `sensitive = true` to prevent Terraform from printing it in plain text during plan/apply output.

---

## Lab Tasks

### Task 1: Create an Output Value
1. Start the lab in your terminal:
   ```bash
   tld start tf-create-output
   ```
2. Navigate to `~/terraform-expr-challenge`:
   ```bash
   cd ~/terraform-expr-challenge
   ```
3. Open `main.tf` and add an `output` block referencing the `local_file.out` resource:
   ```hcl
   output "file_content" {
     value = local_file.out.content
   }
   ```
4. Initialize the workspace and apply the configuration:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```
5. Verify the task:
   ```bash
   tld check
   ```
