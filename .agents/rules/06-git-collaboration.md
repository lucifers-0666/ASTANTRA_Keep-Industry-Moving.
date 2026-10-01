# 06 — Git Collaboration, Safety & Rollback Procedures

Contributors: **Zed** (UI/UX Lead), **Jay** (Public Frontend), **Uday** (Authentication & Core Frontend).

---

## 1. Branch Strategy & Daily Etiquette

- **Branch Naming**: `phase1/<area>-<feature-description>`
  - Examples: `phase1/home-search-hero`, `phase1/parts-filter-ledger`, `phase1/tokens-setup`.
- **Pre-Flight Routine**:
  1. Inspect status: `git status` and `git branch --show-current`.
  2. Sync base branch: `git checkout main && git pull origin main`.
  3. Create dedicated feature branch.
- **File Ownership Awareness**:
  - Shared master assets (`MasterPages/Site.Master`, `Content/css/tokens.css`, `Content/css/components.css`) should be coordinated with the UI lead (Zed) to prevent merge conflicts.
  - Work on isolated page-specific files (`Content/css/public/<page>.css`) whenever possible.

---

## 2. Commit Standards

- **Conventional Structure**: `area: what changed (why)`
  - Good: `home: introduce search-first hero and reduce section count to 5`
  - Good: `tokens: establish industrial color variables and font stacks`
  - Bad: `updated stuff`, `fixes`, `ui changes`
- **Never Commit**: Secrets, database credentials, build artifacts (`bin/`, `obj/`), user-specific IDE cache (`.vs/`), or node runtime dependencies (`node_modules/`).

---

## 3. Forbidden Git Operations

The following commands are strictly prohibited on shared branches (`main`):
- `git push --force` or `git push -f`
- `git reset --hard` on commits that have already been pushed to remote
- Interactive rebase or history rewriting on published commits
- Committing incomplete or untested work directly to `main` without PR review

---

## 4. Mandatory Safe Rollback Procedure

When an undo or rollback of published commits is required:
1. **Never use `git reset --hard`** on published branches.
2. **Create a Backup Branch**: Always point a named backup branch to current HEAD (e.g., `backup/before-rollback-<timestamp>`) before modifying state.
3. **Use Safe Forward Reverts**: Revert commits in reverse chronological order:
   ```bash
   git revert --no-edit <newer-commit>
   git revert --no-edit <older-commit>
   ```
4. **Verify Tree Equality**: Validate that the resulting working tree precisely matches the target commit (`git diff <target-commit> HEAD`).
5. **Verify Solution Build**: Run full MSBuild compilation to confirm 0 errors.
6. **Push Revert Commits**: Push forward reverts cleanly to remote (`git push origin main`).

