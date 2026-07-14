# Understanding Plan and Apply

Once configurations are valid, you execute the provisioning workflow:

## 1. Plan
The `terraform plan` command creates an execution plan. It compares the requested changes with the current infrastructure state and shows:
- Green `+` for resources to be created.
- Yellow `~` for resources to be modified.
- Red `-` for resources to be destroyed.

## 2. Apply
The `terraform apply` command executes the actions proposed in the plan.
By default, it prompts you for confirmation (`yes`) before applying.
Upon completion, it saves the mapping metadata into a file called `terraform.tfstate`.

## The State File
The state file acts as a single source of truth representing what is actually deployed. **Never edit the state file manually.**
