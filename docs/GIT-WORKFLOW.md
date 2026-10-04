# Git Branch and Pull Request Workflow

## Long-lived branches
- `main` — protected integration branch.
- `zaid/changes` — Zaid.
- `jay/changes` — Jay.
- `uday/changes` — Uday.

## Rules
- Never push directly to `main`, force-push or rewrite shared history.
- Never reset/delete/merge without understanding impact and required approval.
- Check unique commits, open PRs and collaborator work before deleting a branch.
- Do not merge two branches with potentially duplicate work without comparing history and diffs.

## Start work
```powershell
git status
git fetch origin --prune
git switch <your-branch>
git pull --ff-only origin <your-branch>
```

Use only your assigned branch. Review before commit:
```powershell
git status
git diff --check
git diff --stat
git diff
git add <only-related-files>
git commit -m "Describe the task completed"
git push origin <your-branch>
```

Replace placeholders; do not stage unrelated files blindly.

## Pull requests
- Base: `main`; head: contributor's branch.
- Include purpose, files changed, actual tests, UI screenshots and limitations.
- Merge only after review and required tests pass.
- Do not merge both `phase1/brand-astantra-identity` and `feature/astantra-branding-review` blindly; recovery branch may duplicate the same work.

## Branch deletion checklist
Owner approval, unique commits preserved, no dependent open PR/collaborator, replacement verified, and target is not `main` or a required contributor branch. If a branch disappears, inspect PRs, history, local reflogs and other clones before assuming commits are lost.
