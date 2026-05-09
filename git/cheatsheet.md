# Git Commands

## Table of Contents

- [Configuration](#configuration)
- [Create or clone repositories](#create-or-clone-repositories)
- [Check repository status](#check-repository-status)
- [Add changes to the staging area](#add-changes-to-the-staging-area)
- [Create commits](#create-commits)
- [Working with branches](#working-with-branches)
- [Modify history](#modify-history)
- [Synchronize with remotes](#synchronize-with-remotes)
- [Merge and rebase](#merge-and-rebase)
- [Differences and change review](#differences-and-change-review)
- [Undo changes](#undo-changes)
- [Stash: store changes temporarily](#stash-store-changes-temporarily)
- [Tags](#tags)
- [Search history](#search-history)
- [Clean the repository](#clean-the-repository)
- [Worktrees](#worktrees)

---

## Configuration

Configure global user:

```bash
git config --list  # Show the current Git configuration
git config --global user.name "Your Name"  # Configure the global user name
git config --global user.email "your.email@example.com"  # Configure the global user email
git config --global init.defaultBranch main  # Configure the default branch for new repositories
git config --global core.editor "<code --wait | vim | nano>"  # Configure the default editor
git config --global color.ui auto  # Enable colors in command output
git config --global merge.tool meld  # Configure a visual merge tool
```

Recommended line ending configuration:

```bash
git config --global core.autocrlf true  # Recommended on Windows
git config --global core.autocrlf input  # Recommended on Linux/macOS
```

Configuration files:

| Scope | Location | Command Flag |
|-------|----------|--------------|
| **Repository** | `<repo>/.git/config` | `--local` |
| **User** | `~/.gitconfig` | `--global` |
| **System** | `/etc/gitconfig` | `--system` |

---

## Create or clone repositories

```bash
git init  # Initialize a new repository
git init <folder>  # Initialize a new repository in a specific folder
git clone https://github.com/user/repository.git <folder optional>  # Clone an existing repository
git clone --depth 1 https://github.com/user/repository.git  # Clone only the latest history
git remote -v  # Show configured remotes
git remote add origin https://github.com/user/repository.git  # Add a remote repository
git remote set-url origin git@github.com:user/repository.git  # Change the remote repository URL
git remote remove origin  # Remove a remote
git remote rename origin upstream  # Rename a remote
```

---

## Check repository status

View general status:

```bash
git status  # Show the general status
git status -s  # Show short status
git status -sb  # Show short status including branch information
git branch  # Show local branches, including the current one
git branch --show-current  # Show the current branch
git ls-files  # List tracked files
git ls-files --others --exclude-standard  # List untracked files that are not ignored
```

View the current HEAD and references:

```bash
git show --summary  # Show a summary of the current commit
git rev-parse HEAD  # Show the current commit hash
git describe --tags --always  # Show the closest tag or commit hash
```

---

## Add changes to the staging area

```bash
git add <file> <file>  # Add specific files
git add .  # Add changes from the current directory
git add -A  # Add all changes, including deletions
git add -u  # Add modifications and deletions, but not new untracked files
git add -p <file>  # Add changes interactively by chunks
git mv <old-name> <new-name>  # Rename or move a tracked file
git rm <file>  # Remove a file from the working tree and from Git
git rm --cached <file>  # Stop tracking a file without deleting it locally
git restore --staged <file>  # Remove a file from staging without losing changes
```

---

## Create commits

```bash
git commit -m "Short description of the change"  # Create a commit with a message
git commit  # Create a commit using the configured editor
git commit -v  # Create a commit and show the diff in the editor
git commit -am "Short description of the change"  # Add and commit tracked files only. It does not add new untracked files
git commit --allow-empty -m "Trigger deployment"  # Create an empty commit
git commit --amend  # Modify the last commit
git commit --amend -m "New message"  # Modify the last commit message
git commit --amend --no-edit  # Add staged changes to the last commit without changing its message
```

---

## Working with branches

List and create branches:

```bash
git branch  # List local branches
git branch -a  # List local and remote branches
git branch -r  # List remote branches
git branch <name>  # Create a branch
git switch <name>  # Switch to a branch
git switch -c <name>  # Create and switch to a branch
git checkout -b <name>  # Create and switch to a branch using the older checkout syntax
git switch -  # Switch to the previous branch
```

Rename and delete branches:

```bash
git branch -m <new-name>  # Rename the current branch
git branch -m <old-name> <new-name>  # Rename a specific local branch
git branch -d <name>  # Delete a local branch already merged
git branch -D <name>  # Force delete a local branch
git push origin --delete <name>  # Delete a remote branch
```

Track remote branches:

```bash
git switch --track origin/<name>  # Create a local branch that tracks a remote branch
git branch --set-upstream-to=origin/<name>  # Set upstream branch for the current branch
git push -u origin <name>  # Push a branch and set upstream tracking
```

---

## Modify history

Use these commands carefully, especially if the commits have already been pushed and other people may have based work on them.

```bash
git reset HEAD^  # Move HEAD one commit back, keeping changes in the working tree
git reset --soft HEAD~1  # Remove the last commit and keep changes staged
git reset --mixed HEAD~1  # Remove the last commit and keep changes unstaged
git reset --hard HEAD~1  # Remove the last commit and discard changes
git rebase -i HEAD~6  # Interactively edit the last 6 commits
git commit --amend  # Modify the last commit
git commit --amend -m "New message"  # Modify the last commit message
git push --force-with-lease  # Safely force push rewritten history
```

---

## Synchronize with remotes

```bash
git fetch  # Download remote information without merging changes
git fetch --all  # Fetch information from all remotes
git fetch --prune  # Remove local references to deleted remote branches
git pull  # Download and merge changes
git pull --rebase  # Download and replay your commits on top of the remote branch
git pull --ff-only  # Pull only if a fast-forward is possible
git push  # Upload local commits
git push -u origin <name>  # Push a new branch and set upstream
git push origin <name>  # Push changes to a specific branch
git push --force-with-lease  # Force push safely, protecting others' work
```

---

## Merge and rebase

Merge branches:

```bash
git merge <branch>  # Merge a branch into the current branch
git merge --no-ff <branch>  # Force a merge commit
git merge --ff-only <branch>  # Merge only if a fast-forward is possible
git merge --abort  # Abort a merge with conflicts
```

Rebase branches:

```bash
git rebase <branch>  # Reapply current branch commits on top of another branch
git rebase main  # Reapply current branch commits on top of main
git rebase --continue  # Continue a rebase after resolving conflicts
git rebase --abort  # Abort the rebase
git rebase --skip  # Skip the current commit during a rebase
```

Cherry-pick commits:

```bash
git cherry-pick <commit-hash>  # Apply one specific commit to the current branch
git cherry-pick <commit-1> <commit-2>  # Apply several commits
git cherry-pick --abort  # Abort a cherry-pick with conflicts
```

---

## Differences and change review

```bash
git diff  # Show unstaged changes
git diff --staged  # Show staged changes
git diff --cached  # Same as git diff --staged
git diff HEAD  # Show all changes compared to the last commit
git diff <branch-1>..<branch-2>  # Compare two branches
git diff --name-only <branch-1>..<branch-2>  # Show modified files between two branches
git diff --name-status <branch-1>..<branch-2>  # Show modified files and change type
git diff --stat  # Show a summary of changed files
git show <commit-hash>  # Show changes from a specific commit
git show --stat <commit-hash>  # Show summary of a specific commit
```

Review staged files:

```bash
git diff --staged --name-only  # Show staged file names
git diff --staged --stat  # Show staged change summary
```

---

## Undo changes

```bash
git restore <file>  # Discard unstaged changes in a file
git restore .  # Discard all unstaged changes in the current directory
git restore --staged <file>  # Remove a file from staging
git restore --source=<commit-hash> <file>  # Restore a file from a specific commit
git reset --soft HEAD~1  # Undo the last commit and keep changes staged
git reset --mixed HEAD~1  # Undo the last commit and keep changes in the working tree
git reset --hard HEAD~1  # Undo the last commit and discard changes
git revert <commit-hash>  # Revert an already published commit by creating a new commit
```

Undo pushed commits safely:

```bash
git revert <commit-hash>  # Recommended for public/shared history
git revert <oldest-commit>^..<newest-commit>  # Revert a range of commits
```

---

## Stash: store changes temporarily

```bash
git stash  # Store changes temporarily
git stash push -m "<message>"  # Store changes with a description
git stash -u  # Store changes including untracked files
git stash -a  # Store changes including ignored files
git stash --keep-index  # Store only unstaged changes
git stash list  # List stashes
git stash show stash@{0}  # Show a stash summary
git stash show -p stash@{0}  # Show the full patch of a stash
git stash pop  # Apply the latest stash and remove it from the list
git stash apply stash@{0}  # Apply a stash without removing it
git stash drop stash@{0}  # Delete a specific stash
git stash clear  # Delete all stashes
git stash branch <branch-name> stash@{0}  # Create a branch from a stash
```

---

## Tags

List tags:

```bash
git tag  # List tags
git tag -l "v1.*"  # List tags matching a pattern
git tag v1.0.0  # Create a lightweight tag
git tag -a v1.0.0 -m "Version 1.0.0"  # Create an annotated tag
git show v1.0.0  # Show tag information
git push origin v1.0.0  # Push one tag
git push --tags  # Push all tags
git tag -d v1.0.0  # Delete a local tag
git push origin --delete v1.0.0  # Delete a remote tag
git switch -c hotfix/v1.0.0 v1.0.0  # Create a branch from a tag
```

Recommended usage:

```text
Use annotated tags for releases:
git tag -a v1.2.0 -m "Release v1.2.0"
```

---

## Search history

View history:

```bash
git log  # Show basic history
git log <branch>  # Show history for a branch
git log -- <file>  # Show commits that touched a file
git log --follow -- <file>  # Show file history, including renames
git log --oneline  # Show compact history
git log --oneline --graph --decorate --all  # Show history as a graph
git log --graph <branch>  # Show branch history as a graph
git log --stat  # Show file change summary for each commit
git log -p  # Show patches for each commit
```

Search commits:

```bash
git log --grep="<text>"  # Search commits by message
git log -S "<text>"  # Search commits that changed the number of occurrences of a string
git log -G "<regex>"  # Search commits whose patch matches a regex
git log --author="<name>"  # Search commits by author
git log --since="<date>" --until="<date>"  # Search commits between dates
git log --diff-filter=D --summary -- <path>  # Find when a file was deleted
git blame <file>  # Show who last changed each line of a file
```

Useful date examples:

```bash
git log --since="2 weeks ago"
git log --since="2024-01-01" --until="2024-12-31"
```

---

## Clean the repository

Always run the dry-run commands first before deleting files.

```bash
git clean -n  # Show untracked files that would be deleted
git clean -f  # Delete untracked files
git clean -dn  # Show untracked folders that would be deleted
git clean -df  # Delete untracked files and folders
git clean -fdx  # Delete untracked and ignored files
git clean -i  # Interactive clean mode
```

---

## Worktrees

```bash
git worktree add <path> <branch>  # Create a new working tree from an existing branch
git worktree add -b <new-branch> <path> <base-branch>  # Create a new branch in a new working tree
git worktree list  # List worktrees
git worktree remove <path>  # Remove a worktree
git worktree prune  # Remove stale worktree metadata
```

Example:

```bash
git worktree add ../project-hotfix hotfix/login-error  # Work on a hotfix without changing the current working tree
```

---
