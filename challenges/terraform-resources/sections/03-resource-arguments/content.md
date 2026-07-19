# Resource Arguments

Resource arguments configure resource attributes. Each resource type supports different arguments.

For example, the `local_file` resource type requires `filename` and optionally accepts `content` or `directory_permission`.

## Arguments vs Attributes:
- **Arguments:** Settings you configure on a resource (inputs).
- **Attributes:** Values returned by a resource after provisioning (outputs, e.g., `id`, `hex`).
