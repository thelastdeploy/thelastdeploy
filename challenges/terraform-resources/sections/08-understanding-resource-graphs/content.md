# Understanding Resource Graphs

Terraform builds a dependency graph of all resources declared in your configuration.

By reading this graph, Terraform determines:
- Which resources have no dependencies and can be created in parallel.
- The precise order required to provision dependent resources.

You can inspect the dependency graph visually by running:
```bash
terraform graph | dot -Tpng > graph.png
```
