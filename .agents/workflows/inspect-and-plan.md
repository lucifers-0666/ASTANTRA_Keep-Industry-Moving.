---
description: Inspect the repository and produce a structured plan before editing. Run this first on every task.
---

# Workflow: /inspect-and-plan

## Step 1: Repository Status
- Run `git status` and `git branch --show-current`.
- Confirm working tree is clean and on the intended feature branch.

## Step 2: Rules & Scope Verification
- Consult `AGENTS.md` and `.agents/rules/` to confirm the active phase scope.
- In Phase 1, confirm that no backend, database, auth, or `*.cs` logic will be modified.

## Step 3: Source Code Inspection
- Open the target `.aspx` page and its code-behind (`.aspx.cs`) in **read-only mode**.
- Catalog all `runat="server"` controls:
  - Control IDs (`btnSearch`, `rptParts`, `txtQuery`, etc.)
  - Event subscriptions (`OnClick`, `OnItemCommand`, etc.)
  - Data-bound containers (`asp:Repeater`, `asp:GridView`, `asp:ListView`)
  - Server validation controls (`asp:RequiredFieldValidator`, etc.)
- Inspect `MasterPages/Site.Master` for exposed `<asp:ContentPlaceHolder>` regions.
- Review existing CSS classes and check where they are defined.

## Step 4: Structured Plan Output
Format the plan with the following standard sections:
```markdown
### 1. What Exists Now
### 2. Required Modifications (Aesthetic & UX rationale)
### 3. Files to Create / Modify
### 4. Files that Must Remain Untouched
### 5. Preserved Server Control IDs & Events
### 6. Potential Risks & Edge Cases
### 7. Verification & Testing Strategy
```

## Step 5: Execution Gate
- For routine, reversible, in-scope frontend tasks, proceed directly to implementation.
- If the task touches protected files, alters database/auth logic, or changes architecture, **STOP and request user confirmation**.

