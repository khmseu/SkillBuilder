---
name: git-start
description: "Use when getting started with Git workflows: initial setup, init/clone, staging and commits, branching, remotes, pull/fetch/push, stashing, cleaning, and safe collaboration practices based on official git-scm docs."
---

# Git Start

## Domain Focus

Use this skill when working with Git fundamentals and day-to-day command-line workflows, including:

- First-time Git setup and repository initialization.
- Staging, diffing, committing, and .gitignore hygiene.
- Branch creation/switching/merging and basic history navigation.
- Remote collaboration with clone/fetch/pull/push.
- Temporary work management with stash and safe cleanup practices.

This skill is for practical, safe Git usage in local and collaborative environments.

## Best Practices

### First-Time Setup

- Configure identity before committing:
  - `git config --global user.name "Your Name"`
  - `git config --global user.email you@example.com`
- Set default branch name explicitly if desired:
  - `git config --global init.defaultBranch main`
- Validate effective config and origins:
  - `git config --list --show-origin`

### Repository Creation and Cloning

- For new projects:
  - `git init`
  - `git add .`
  - `git commit -m "Initial commit"`
- For existing remote projects, prefer `git clone <url>` over manual setup.
- Keep one repository per project root; avoid nested accidental repos.

### Staging and Committing

- Use the status → stage → diff → commit loop:
  - `git status`
  - `git add <paths>`
  - `git diff` and `git diff --staged`
  - `git commit`
- Remember `git add` stages content snapshots; rerun after edits.
- Prefer focused commits by area/intent, not large mixed commits.
- Use clear commit messages: short subject line + optional detailed body.

### Ignore and Track Correctly

- Create `.gitignore` early to avoid committing generated/build artifacts.
- Use `git rm --cached <file>` for files you want to keep locally but stop tracking.
- Avoid broad ignore patterns that hide real source changes.

### Branching and Integration

- Create short-lived topic branches:
  - `git switch -c feature/scope`
- Switch with `git switch` (modern) rather than overloading `checkout`.
- Merge or rebase intentionally based on team policy.
- Use logs with graph/decorate when reasoning about branch topology:
  - `git log --oneline --decorate --graph --all`

### Collaboration with Remotes

- Use `git fetch` to inspect incoming changes before merge.
- Use `git pull` when you want fetch + merge into current branch.
- Keep local branches up-to-date before opening/merging PRs.
- Push frequently on feature branches to preserve backup and reviewability.

### Stash and Cleanup Safety

- Use stash to park partial work during context switches:
  - `git stash push`
  - `git stash list`
  - `git stash apply` / `git stash pop`
- Include untracked files when needed:
  - `git stash -u`
- Prefer dry-run before cleaning:
  - `git clean -n -d`
- Only force clean after confirming output:
  - `git clean -f -d` (and `-x` only when truly necessary)

## Common Pitfalls

- Committing without identity set, resulting in incorrect author metadata.
- Assuming `git add` tracks future edits automatically.
- Using `git commit -a` and unintentionally bundling unrelated tracked changes.
- Running destructive commands (`git clean -f`, hard resets) without preview.
- Pulling with uncommitted local changes and creating avoidable conflicts.
- Rewriting shared history (`reset --hard` on public branches) instead of using safer undo patterns.
- Forgetting to use `.gitignore` early, leading to noisy history.

## Practical Patterns

### 1) New Repository

```bash
git init
git add .
git commit -m "Initial commit"
```

### 2) Daily Commit Cycle

```bash
git status
git add src/fileA src/fileB
git diff --staged
git commit -m "Implement feature X behavior"
```

### 3) Feature Branch Workflow

```bash
git switch -c feature/login-form
# edit/test
git add .
git commit -m "Add login form validation"
git switch main
git pull
git switch feature/login-form
git rebase main
```

### 4) Inspect Before Integrating

```bash
git fetch origin
git log --oneline HEAD..origin/main
git merge origin/main
```

### 5) Stash During Interruptions

```bash
git stash push -u -m "WIP: refactor parser"
git switch hotfix/urgent-issue
# later
git switch -
git stash pop
```

### 6) Safe Cleanup

```bash
git clean -n -d
git clean -f -d
```

## Review Checklist

- Is Git identity configured and verified?
- Are changes intentionally staged (`git diff --staged` checked)?
- Is commit scope focused and message meaningful?
- Are branch and integration steps aligned with team policy?
- Were destructive commands preceded by inspection/dry-run?
- Are ignored and tracked files configured correctly?

## Output Expectations

When producing Git guidance or commands:

- Prefer safe, reversible steps by default.
- Explain command intent, especially for history-altering operations.
- Separate local-only actions from remote/shared-branch actions.
- Recommend inspection commands (`status`, `diff`, `log`, `fetch`) before mutation commands.
- Highlight risk levels for commands that delete data or rewrite history.

## Source Docs

- https://git-scm.com/docs/gittutorial
- https://git-scm.com/docs/giteveryday
- https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
- https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository
- https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository
- https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell
- https://git-scm.com/book/en/v2/Git-Tools-Stashing-and-Cleaning
