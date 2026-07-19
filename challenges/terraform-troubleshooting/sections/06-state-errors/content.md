# State Errors

State errors manifest as missing tracking, state lock failures, or corrupted `.tfstate` files.

## Resolution Techniques:
1. **Missing Tracking:** Use `terraform import` or run `terraform apply` to rebuild state mapping.
2. **Stale Lock:** If a process crashed leaving a lock behind, run `terraform force-unlock <LOCK_ID>`.
