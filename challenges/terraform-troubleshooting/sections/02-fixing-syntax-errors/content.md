# Fixing Syntax Errors

Syntax errors occur when Terraform fails to parse your HCL files into valid blocks.

## Common Syntax Bugs:
- **Missing Braces (`{}`):** Forgetting to close a block or array.
- **Unclosed Quotes (`""`):** Missing closing double quotation mark on strings.
- **Malformed Comments:** Using unsupported syntax or leaving multi-line comments unclosed.

Run `terraform fmt` to automatically highlight and format syntax structure.
