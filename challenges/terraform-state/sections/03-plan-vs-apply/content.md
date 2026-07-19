# Plan vs Apply

`terraform plan` compares your configuration files against state and real-world infrastructure to generate an execution plan.

## Saving Execution Plans
For automated pipelines, you can save an execution plan to an output file:
```bash
terraform plan -out=tfplan
```
Then, execute exact changes from the saved file using:
```bash
terraform apply tfplan
```
This guarantees that only the pre-approved plan is applied, avoiding unexpected changes if infrastructure drifted between plan and apply.
