# Local Testing Checklist

Only mark checks passed if they were actually run.

## Before editing
- [ ] Confirm assigned branch, not `main`.
- [ ] Run `git status` and understand existing changes.
- [ ] Fetch intended baseline; read task acceptance criteria.
- [ ] Confirm local configuration exists without exposing secrets.

## Build/source
- [ ] Open existing `.sln` in supported Visual Studio and build.
- [ ] Resolve new compile errors; review new warnings.
- [ ] Run `git diff --check`; inspect `git diff --stat` and full diff.
- [ ] No secrets, local DB files, `bin/`, `obj/` or unrelated files included.

## UI/page
- [ ] Run application using existing supported configuration.
- [ ] Open changed page directly and via navigation.
- [ ] Check master page, console/network errors and missing assets.
- [ ] Check 360px, 768px, 1024px and desktop.
- [ ] Check keyboard use, visible focus, labels and postback.

## Web Forms
- [ ] IDs and `runat="server"` remain valid.
- [ ] Event handlers fire; validators/groups work.
- [ ] `Page.IsPostBack` does not cause lost input or repeated binding.
- [ ] Master-page placeholders, auth and role navigation still work.

## Database/business flow
- [ ] Valid input succeeds; invalid/required input is rejected.
- [ ] Boundary lengths, duplicates and conflicts are handled.
- [ ] Database failure never shows false success.
- [ ] User input is parameterized; resources are disposed.
- [ ] Unauthorized users cannot access or modify protected records.
- [ ] Verify persistence using safe test data.

## Authentication (when relevant)
- [ ] Valid/invalid credentials behave correctly.
- [ ] Anonymous access to protected pages is blocked.
- [ ] Role access, direct URLs and logout are tested.
- [ ] Secrets are not displayed or logged.

## Before push
```powershell
git status
git diff --check
git diff --stat
git diff
```
- [ ] Commit only task-related files.
- [ ] Push only assigned branch.
- [ ] PR contains summary, tests actually run, UI screenshots and known limitations.

Test report: Task / Branch / Files / Build result / Manual tests / DB tests / Viewports / Known issues / Not tested / Reviewer.
