# 01 — Project Guardrails & Scope Boundaries

## 1. Project Phase Governance

| Phase | Module / Area | Backend/DB Edits Allowed? | Status |
| :--- | :--- | :---: | :--- |
| **Phase 1** | Public Visitor Pages, Master Page, Public CSS/JS | **STRICTLY NO** | **Active (Current)** |
| **Phase 2** | Authentication & Role Onboarding (`Account/`) | Authorized in writing | Planned |
| **Phase 3** | Factory Buyer Portal (`Factory/`) | Authorized in writing | Planned |
| **Phase 4** | Spare-Part Supplier Hub (`Supplier/`) | Authorized in writing | Planned |
| **Phase 5** | Field Technician Portal (`Technician/`) | Authorized in writing | Planned |
| **Phase 6** | System Admin Portal (`Admin/`) | Authorized in writing | Planned |
| **Phase 7** | System Integration, Verification & Viva Prep | Bug fixes only | Planned |

Work strictly within the currently active phase. Never commence subsequent phases early without explicit authorization.

---

## 2. Protected Paths in Phase 1 (Strictly Read-Only)

- `Database/` (DDL schema scripts, migration SQL, seed files)
- `App_Code/` (services, repositories, models, auth helpers, db factories)
- `Account/` (login, registration, password hashing logic)
- Configuration & Manifests: `Web.config`, `packages.config`, `*.csproj`, `*.sln`
- All code-behind logic: `*.aspx.cs`, `*.master.cs`, `*.designer.cs`

Reading these files to inspect control IDs, data models, and event wiring is required; modifying them is forbidden.

---

## 3. Autonomous Execution vs. Stop-and-Ask Boundaries

### Safe Autonomous Work (Proceed without asking):
- Standard CSS modifications, design token adjustments, spacing, responsive layout, and typography refinements.
- HTML markup restructuring that preserves all server control tags (`runat="server"`, `ID`, event handlers).
- Adding accessible attributes (`aria-*`, `role`, `tabindex`), external `<label>` elements, and visible focus rings.
- Compiling the project (`MSBuild`) to ensure zero build errors.

### Stop and Request Explicit Confirmation Before:
- Any change requiring an edit to a `.cs`, `.aspx.cs`, `.sql`, or `.config` file.
- Any change to authentication, authorization roles, session state, or security behavior.
- Deleting files or assets (always search for all incoming references first).
- Installing new npm packages, NuGet dependencies, external CSS frameworks, or font CDNs.
- Any destructive Git operation (`git reset --hard`, `git clean -fd`, `git push --force`, or history rewrites).
- When an existing page or server control behaves differently from what documentation suggests.

---

## 4. Truthfulness & Demo Integrity

- **Inspect Reality First**: Always inspect actual source code before describing functionality; documentation may be outdated.
- **Explicit Demo Labeling**: Simulated catalog items, quote pricing, and placeholder entities must be explicitly labeled as demo/prototype data in markup.
- **No Fabricated Claims**: Never invent metrics, testimonials, partner logos, or fake ISO certifications.
- **Accurate Test Claims**: Never claim a test, build, or cross-browser verification passed unless you actually executed it. State "not tested" when unverified.

