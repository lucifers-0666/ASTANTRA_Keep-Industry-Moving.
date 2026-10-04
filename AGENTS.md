# ASTANTRA (formerly SPAREFINDER) — Agent Instructions & Execution Rules

ASTANTRA is an MCA academic and enterprise B2B platform: an industrial spare-parts procurement and emergency maintenance portal built with **ASP.NET Web Forms (C# 7.3, .NET Framework 4.8), parameterized ADO.NET, SQL Server LocalDB, CSS Custom Properties / Tailwind CSS, and Vanilla JavaScript**.

- **Official Brand Guide**: [`docs/brand-guide.md`](file:///E:/ASP.NET%20MCA/docs/brand-guide.md)
- **Master Project SRS**: [`docs/project-definition.md`](file:///E:/ASP.NET%20MCA/docs/project-definition.md)
- **Architecture & Directory Structure**: [`docs/project-structure.md`](file:///E:/ASP.NET%20MCA/docs/project-structure.md)
- **Authoritative Design System**: [`docs/design-system.md`](file:///E:/ASP.NET%20MCA/docs/design-system.md)

---

## 1. Project Phases & Current Scope

Development proceeds in strictly defined phases:
- **Phase 1 — Public Visitor Experience (FRONTEND ONLY) [CURRENT PHASE]**
  - Scope: `Default.aspx`, `Public/Parts.aspx`, `Public/Suppliers.aspx`, `Public/Technicians.aspx`, `Public/HowItWorks.aspx`, `Public/WhyUs.aspx`, `Public/Emergency.aspx`, `MasterPages/Site.Master`, and associated public CSS/JS assets.
- **Phase 2 — Authentication & Multi-Role Onboarding** (`Account/Login.aspx`, `Account/Register.aspx`)
- **Phase 3 — Factory Buyer Portal** (`Factory/`)
- **Phase 4 — Spare-Part Supplier Hub** (`Supplier/`)
- **Phase 5 — Field Technician Portal** (`Technician/`)
- **Phase 6 — Administrator Governance Portal** (`Admin/`)
- **Phase 7 — End-to-End Integration, Testing, Documentation & Viva Preparation**

Work strictly within the authorized phase. Never start future phases early without explicit approval.

---

## 2. Core Non-Negotiables

1. **Stack is Locked**: ASP.NET Web Forms on .NET Framework 4.8, C# 7.3, parameterized ADO.NET, SQL Server LocalDB. No React, Angular, Vue, SPA rewrite, Entity Framework, or modern JS bundler runtime dependencies.
2. **Phase 1 Backend Freeze**: Zero modifications to `Database/`, `App_Code/`, `Account/`, `Web.config`, `*.csproj`, or `*.aspx.cs` business/data logic during Phase 1. If a UI change seems to require backend changes, STOP and request confirmation.
3. **Academic Explainability (Viva Readiness)**: Every line of C#, HTML, CSS, and JS must be easily understandable and explainable by an MCA student during a viva examination. Simple beats clever.
4. **Authentic Data & Labeling**: No fabricated statistics, fake logos, synthetic customer testimonials, or phantom certifications. All prototype/sample catalog items must be visibly labeled as demo data.
5. **Rigorous Test Truthfulness**: Never state a test passed unless you actually executed it. State "not run" or "manually unverified" when appropriate.

---

## 3. Autonomous Execution vs. Confirmation Boundary

To maintain velocity while ensuring safety:

### Autonomous Actions (Proceed without asking):
- Routine read-only codebase inspections, file viewing, and searching.
- Standard frontend styling, CSS variables, typography adjustments, spacing, and layout refinements within the approved design palette.
- Fixing markup structure, responsive breakpoints, accessible ARIA attributes, and semantic HTML without altering server control IDs or events.
- Creating or editing authorized stylesheets (`Content/css/`) and client scripts (`Content/js/`).
- Running non-destructive build verifications (e.g., MSBuild).

### Stop & Require User Approval Before:
- Executing destructive Git commands (`git reset --hard`, `git clean -fd`, `git push --force`, or history rewriting).
- Deleting files or tables.
- Modifying authentication, authorization, session logic, database schema, or SQL queries.
- Introducing external libraries, CDNs, or architectural dependencies.
- Editing files explicitly excluded from the current phase scope.
- Overwriting uncommitted work or other contributors' changes.

*Note on Permissions*: Never attempt to bypass OS, shell, or tool permission gates. If a command is blocked or denied, explain what was blocked and provide a safe alternative.

---

## 4. Standard Working Loop

Every task follows a strict 6-step lifecycle:
1. **Inspect**: Check git status, branch, existing code-behind controls, and stylesheets.
2. **Plan**: Define what exists, what must change, files touched, controls preserved, and test strategy.
3. **Implement**: Make clean, minimal, explainable edits following the design system tokens.
4. **Test**: Run compilation/build (`MSBuild`), verify layout across breakpoints, check postback integrity.
5. **Review**: Audit against AI-cliché patterns (`anti-ai-ui-audit`), check explainability, update viva notes.
6. **Report**: Deliver a concise summary of files changed, decisions made, tests performed vs not run, and remaining issues.

---

## 5. Directory of Rules & Skills

All detailed rules are located in [`.agents/rules/`](file:///E:/ASP.NET%20MCA/.agents/rules):
- [`01-project-guardrails.md`](file:///E:/ASP.NET%20MCA/.agents/rules/01-project-guardrails.md) — Scope boundaries, protected paths, safety triggers.
- [`02-code-explainability.md`](file:///E:/ASP.NET%20MCA/.agents/rules/02-code-explainability.md) — Student readability, file headers, viva notes, dependencies.
- [`03-ui-design-system.md`](file:///E:/ASP.NET%20MCA/.agents/rules/03-ui-design-system.md) — Design tokens, color palette, typography, anti-AI UI rules.
- [`04-motion-and-performance.md`](file:///E:/ASP.NET%20MCA/.agents/rules/04-motion-and-performance.md) — Restrained animations, hardware acceleration, performance budgets.
- [`05-aspnet-webforms-rules.md`](file:///E:/ASP.NET%20MCA/.agents/rules/05-aspnet-webforms-rules.md) — Web Forms safety, server control IDs, event preservation, postbacks.
- [`06-git-collaboration.md`](file:///E:/ASP.NET%20MCA/.agents/rules/06-git-collaboration.md) — Multi-contributor safety, branch naming, commit standards, forward reverts.

Specialized Skills & Workflows:
- Skill: [`.agents/skills/anti-ai-ui-audit/SKILL.md`](file:///E:/ASP.NET%20MCA/.agents/skills/anti-ai-ui-audit/SKILL.md)
- Workflows: [`.agents/workflows/`](file:///E:/ASP.NET%20MCA/.agents/workflows) (`inspect-and-plan.md`, `build-public-page.md`, `review-and-explain.md`, `pre-commit-check.md`)
- Tracking: [`docs/AI_USAGE_LOG.md`](file:///E:/ASP.NET%20MCA/docs/AI_USAGE_LOG.md), [`docs/DECISIONS.md`](file:///E:/ASP.NET%20MCA/docs/DECISIONS.md), [`docs/PHASE_CHECKLIST.md`](file:///E:/ASP.NET%20MCA/docs/PHASE_CHECKLIST.md), [`docs/VIVA_NOTES.md`](file:///E:/ASP.NET%20MCA/docs/VIVA_NOTES.md).

