# Why Modules Exist

A **Terraform Module** is a container for multiple resources that are used together. Every Terraform configuration has at least one module, known as the **root module**.

## Core Benefits of Modules:
1. **Reusability:** Write infrastructure code once and deploy it multiple times across development, staging, and production.
2. **Abstraction:** Hide implementation complexity behind simple configuration inputs.
3. **Consistency:** Enforce company security policies and compliance by mandating standard modules.
4. **Maintainability:** Isolate resource changes so updates to one module don't break unrelated infrastructure.
