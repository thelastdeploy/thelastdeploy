# Module Errors

Module errors happen when:
- The `source` directory or URL cannot be resolved.
- A required input variable is missing in the `module` invocation block.
- Module outputs referenced in root configurations are named incorrectly.

Always run `terraform init` after modifying module sources or paths.
