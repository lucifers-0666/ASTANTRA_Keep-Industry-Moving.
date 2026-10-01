# Architecture & Technical Decisions Log

This log documents major architectural, technology, and design decisions, recording the rationale, rejected alternatives, and approval.

---

## Decision Records

| Date | Topic | Decision Made | Rationale | Rejected Alternatives | Approved By |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 2026-08-31 | Core Architecture | Maintain ASP.NET Web Forms (.NET Framework 4.8) + C# 7.3 | Preserves existing MCA project architecture, stable deployment, clean server lifecycle. | React/Next.js/SPA complete rewrite | Team |
| 2026-08-31 | Data Access Layer | Direct, Parameterized ADO.NET (`SqlConnection`, `SqlCommand`) | Transparent viva explainability, zero ORM abstraction overhead, explicit SQL injection protection. | Entity Framework 6 / EF Core / Dapper | Team |
| 2026-09-01 | UI Aesthetic | Light Industrial Datasheet / Engineering Drawing Aesthetic | Authentic to heavy manufacturing; avoids generic consumer e-commerce and template look. | Glassmorphism, dark crypto theme, gradient SaaS templates | Zed (UI Lead) |
| 2026-09-01 | Animation Stack | CSS Transitions + Lightweight `IntersectionObserver` | Fast, hardware-accelerated, zero external dependencies, explainable in 30 seconds. | Heavy animation runtimes (GSAP, Framer) | Team |
| 2026-09-01 | Typography | `Archivo` (Headings), `IBM Plex Sans` (Body), `IBM Plex Mono` (Specs) | Clean engineered precision; monospace font highlights OEM part numbers and tolerances. | Default Inter, Roboto, Arial | Zed (UI Lead) |
| 2026-10-01 | Git Rollback Strategy | Safe Forward Reverts (`git revert`) with Backup Branching | Preserves shared history, prevents remote merge conflicts, guarantees 100% reproducible state without force-pushing. | `git reset --hard` + force-push | Team |
| 2026-10-01 | Instruction System | Centralized `AGENTS.md` + `.agents/rules/` + Antigravity Skills | Provides one authoritative rule system recognized natively by AI agents and team members alike. | Disjointed multi-tool config files | Team |
| 2026-10-01 | Art Direction & Copy Hierarchy | Direct task-oriented B2B copy, elimination of decorative eyebrow tags, single emergency callout | Strips away generic AI template clichés ("Architectural Workflow Specification", "Priority Escalation Protocol") and duplicate alert banners; makes navigation, hero, and catalog ledgers feel like human-engineered industrial software. | Over-decorated template banners, duplicate emergency sections | Zed / Team |

