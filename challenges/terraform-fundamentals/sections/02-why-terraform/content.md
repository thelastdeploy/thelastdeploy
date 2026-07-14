# Why Terraform?

HashiCorp Terraform is an open-source declarative Infrastructure as Code tool. It allows you to build, change, and version infrastructure safely and efficiently.

## Core Features of Terraform:

1. **Multi-Provider Support:** Terraform can manage infrastructure across major cloud providers (AWS, GCP, Azure), Kubernetes, SaaS integrations, and even local systems (like files or Docker containers).
2. **Declarative State Management:** Terraform keeps track of your real-world infrastructure in a **state file**. When you apply changes, Terraform compares your configuration to the state file and updates only what is necessary.
3. **Execution Plans:** Before making any changes, Terraform generates an execution plan showing exactly what will be created, modified, or destroyed.
4. **Resource Graph:** Terraform builds a dependency graph of all resources to provision them in the correct order, parallelizing operations where possible.
