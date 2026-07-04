# Understanding Remote Repositories

Git is a **distributed** version control system. This means that every developer has a complete copy of the project's history on their local machine. To collaborate with others, Git uses **Remote Repositories** (or "remotes").

---

## What is a Remote Repository?

A remote repository is a version of your project that is hosted on the internet or on a network somewhere. Common hosting providers include:
- GitHub
- GitLab
- Bitbucket

In some environments, remotes can even be directories on the same local filesystem.

---

## Bare Repositories

Remote repositories are typically initialized as **bare repositories**.
- A standard Git repository contains a working directory where you write and edit code files, along with the `.git` metadata folder.
- A **bare repository** has *no working directory*—it contains only the Git history metadata (basically, the contents of the `.git` folder). Because nobody edits files directly on the server, a working directory is not needed.

---

## Key Terms in Collaboration

- **`origin`**: The default name Git gives to the remote repository you cloned from.
- **`upstream`**: Typically refers to the main project repository from which you created a fork.
- **`git remote`**: The command used to inspect, add, rename, or delete connections to remote repositories.
