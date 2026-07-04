# Why Branches Exist

In version control, a **branch** is an independent line of development. You can think of it as a separate workspace or copy of the codebase where you can write code without affecting the main project.

---

## The Purpose of Branching

When working on a software project, branching allows developers to:
- **Isolate Features**: Develop and test new features, bug fixes, or experiments safely without breaking the stable codebase (usually named `main` or `master`).
- **Enable Parallel Development**: Multiple developers can work on different tasks simultaneously in their own branches without interfering with each other's changes.
- **Maintain a Clean History**: By separating work-in-progress code from production-ready code, the team can review and clean up history before integrating changes.

---

## How Git Branches Work Under the Hood

Unlike other version control systems (like SVN) which physically duplicate all files when creating a branch, Git branches are incredibly **lightweight**.

A Git branch is simply a **movable pointer** that points to a specific commit.
- The default branch name in Git is typically `main`.
- When you make a commit on a branch, the branch pointer automatically moves forward to point to the new commit.
- Git uses a special pointer called `HEAD` to keep track of which branch you are currently working on.
