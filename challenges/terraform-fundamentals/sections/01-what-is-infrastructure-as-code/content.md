# What is Infrastructure as Code (IaC)?

Infrastructure as Code (IaC) is the practice of managing and provisioning computer data centers through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools.

## Why use IaC?
- **Consistency:** By using code to define your infrastructure, you prevent human error and configuration drift across environments.
- **Speed:** Provision entire environments in minutes instead of hours or days.
- **Version Control:** You can store your infrastructure definitions in Git, track changes, rollback versions, and perform code reviews just like software application code.
- **Automation:** IaC allows infrastructure management to be integrated directly into your CI/CD pipelines.

## Declarative vs. Imperative
- **Imperative (How):** Focuses on the steps to achieve the desired state (e.g., using bash scripts or CLI commands like `aws ec2 run-instances`).
- **Declarative (What):** Focuses on the final desired state of the system, and the tool figures out how to reach it (e.g., "I need 3 virtual machines" in Terraform).
