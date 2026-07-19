# State Commands

Advanced state management commands allow refactoring code without destroying resources:

- `terraform state mv <OLD_ADDRESS> <NEW_ADDRESS>`: Renames a resource in state.
- `terraform state rm <ADDRESS>`: Removes a resource from state tracking without deleting real infrastructure.
- `terraform state pull`: Outputs raw state contents to stdout.
