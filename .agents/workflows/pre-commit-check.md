---
description: Final safety and integrity check before committing or opening a pull request.
---

# Workflow: /pre-commit-check

## Verification Steps

1. **Working Tree Inspection**:
   - Run `git status` to verify tracked, modified, and untracked files.
2. **Protected Scope Verification**:
   - Confirm that **ZERO** files in protected directories were modified during Phase 1:
     - `Database/`
     - `App_Code/`
     - `Account/`
     - `Web.config`, `packages.config`, `*.csproj`, `*.sln`
     - Any `*.aspx.cs`, `*.master.cs`, or `*.designer.cs` file.
3. **Server Control Integrity**:
   - For all modified `.aspx` and `.master` files, verify that all original `runat="server"`, `ID`, and server event attributes (`OnClick`, etc.) remain intact.
4. **Code Quality & Artifact Cleanup**:
   - Verify absence of debugging statements (`console.log`), placeholder text (`lorem ipsum`), raw hex colors in page stylesheets, unlisted `transition: all`, and arbitrary `!important` tags.
5. **Academic Documentation Check**:
   - Confirm that entries have been added to [`docs/VIVA_NOTES.md`](file:///E:/ASP.NET%20MCA/docs/VIVA_NOTES.md) and [`docs/AI_USAGE_LOG.md`](file:///E:/ASP.NET%20MCA/docs/AI_USAGE_LOG.md).
6. **Solution Build**:
   - Execute MSBuild to ensure 0 errors and 0 warnings.
7. **Suggested Commit Message**:
   - Formulate a clear commit message conforming to: `area: what changed (why)`.
   - **Do NOT execute `git commit` or `git push` automatically.** Present the message to the user for review.

