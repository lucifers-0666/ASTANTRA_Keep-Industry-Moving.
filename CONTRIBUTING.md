# Contributing to SPAREFINDER

**Project Contributors**: Zed (UI/UX Lead), Jay (Public Frontend), Uday (Authentication / Frontend).

---

## 1. Daily Development Workflow

1. **Pull & Branch**: Always pull latest changes before starting work:
   ```bash
   git checkout main
   git pull origin main
   git checkout -b phase1/<feature-name>
   ```
2. **Coordinate Ownership**: Inform team members in advance which `.aspx` pages or stylesheets you plan to edit to prevent merge conflicts.
3. **Use Agent Workflows**: Run `inspect-and-plan` before major edits, followed by `review-and-explain` and `pre-commit-check`.
4. **Inspect the Diff**: Review your own git diff before committing. Ensure you can explain every modified line during viva defense.
5. **Pull Requests**: Open a pull request against `main`. Require at least one peer review before merging.

---

## 2. Responsible & Transparent AI Usage

- All AI coding assistants (Antigravity, Claude, Copilot) must follow [`AGENTS.md`](file:///E:/ASP.NET%20MCA/AGENTS.md) and [`.agents/rules/`](file:///E:/ASP.NET%20MCA/.agents/rules).
- Never paste or accept code that you cannot explain in plain language.
- Document AI contributions in [`docs/AI_USAGE_LOG.md`](file:///E:/ASP.NET%20MCA/docs/AI_USAGE_LOG.md) to maintain academic integrity and satisfy viva evaluation requirements.

---

## 3. Key Reference Documentation

- **Master Agent Rules**: [`AGENTS.md`](file:///E:/ASP.NET%20MCA/AGENTS.md)
- **Detailed Rules**: [`.agents/rules/`](file:///E:/ASP.NET%20MCA/.agents/rules)
- **Project Requirements & SRS**: [`docs/project-definition.md`](file:///E:/ASP.NET%20MCA/docs/project-definition.md)
- **Architecture & Directory Structure**: [`docs/project-structure.md`](file:///E:/ASP.NET%20MCA/docs/project-structure.md)
- **UI Design System & Tokens**: [`docs/design-system.md`](file:///E:/ASP.NET%20MCA/docs/design-system.md)
- **Phase Progress Tracker**: [`docs/PHASE_CHECKLIST.md`](file:///E:/ASP.NET%20MCA/docs/PHASE_CHECKLIST.md)
- **Viva Preparation Notes**: [`docs/VIVA_NOTES.md`](file:///E:/ASP.NET%20MCA/docs/VIVA_NOTES.md)
- **Architectural Decisions**: [`docs/DECISIONS.md`](file:///E:/ASP.NET%20MCA/docs/DECISIONS.md)

