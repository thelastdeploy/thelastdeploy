# What is Terraform State?

Terraform state is a database that maps your HCL configuration code to real-world infrastructure objects created in your cloud or local environments.

## Why is State Required?
1. **Mapping Real-world Objects to Code:** Terraform matches configuration blocks (`resource "local_file" "app"`) to remote IDs.
2. **Metadata Tracking:** State tracks metadata like resource dependencies, pointers, and resource order.
3. **Performance Optimization:** Instead of querying your entire cloud provider infrastructure on every operation, Terraform inspects state metadata.
4. **Concurrency & Locking:** Prevents multiple team members from applying changes simultaneously.
