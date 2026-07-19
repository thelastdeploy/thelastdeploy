# Debugging Workflow

Follow this systematic 6-step checklist whenever troubleshooting broken Terraform infrastructure:

1. **Read the Error Message:** Note the file name and line number.
2. **Run `terraform fmt`:** Clean up indentation and missing brackets.
3. **Run `terraform validate`:** Catch schema and type mismatch bugs.
4. **Enable Logging:** Export `TF_LOG=DEBUG` for detailed trace information.
5. **Inspect State:** Use `terraform state list` and `terraform state show` to verify real-world mappings.
6. **Use Terraform Console:** Test expressions interactively with `terraform console`.
