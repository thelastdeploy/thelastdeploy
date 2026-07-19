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
