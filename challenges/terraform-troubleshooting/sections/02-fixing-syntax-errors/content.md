# Fixing Syntax Errors

Syntax errors occur when Terraform fails to parse your HCL files into valid blocks.

## Common Syntax Bugs:
- **Missing Braces (`{}`):** Forgetting to close a block or array.
- **Unclosed Quotes (`""`):** Missing closing double quotation mark on strings.
- **Malformed Comments:** Using unsupported syntax or leaving multi-line comments unclosed.

Run `terraform fmt` to automatically highlight and format syntax structure.

---

## Lab Tasks

### Task 1: Fix Syntax Errors in Configuration
1. Start the lab in your terminal:
   ```bash
   tld start tf-fix-syntax-errors
   ```
2. Navigate to `~/terraform-troubleshoot-challenge`:
   ```bash
   cd ~/terraform-troubleshoot-challenge
   ```
3. Open `main.tf` and add the missing closing brace `}` to complete the `local_file.syntax_bug` resource block:
   ```hcl
   resource "local_file" "syntax_bug" {
     content  = "broken syntax"
     filename = "/tmp/syntax.txt"
   }
   ```
4. Format the file using `terraform fmt`:
   ```bash
   terraform fmt
   ```
5. Verify the task:
   ```bash
   tld check
   ```
