# Team Ownership and Task Plan

## Zaid — project lead and integration owner
Owns architecture coordination, database/schema review, critical authentication/business flows, integration review and final PR approval. Keep documentation accurate and delegate implementation so knowledge is shared.

## Jay — UI/UX and feature-page implementation
Owns assigned layouts, responsive styling, shared visual consistency and selected feature pages. Preserve Web Forms control contracts. Coordinate before changing master pages or global CSS.

## Uday — guided page development and progressive C# learning
Start with setup notes, reproducible bug reports, manual tests, a simple public page, accessible forms and basic C# event handlers with review. Progress to retrieving and saving records through the approved three-tier flow; do not permanently restrict Uday to documentation.

## Proposed initial backlog (verify existing implementation first)
| Task | Owner | Acceptance criteria |
|---|---|---|
| Audit ASPX pages and inventory | Zaid + Uday | All actual paths, counts, master pages and access identified |
| Audit architecture and DB access | Zaid | Framework, connection key, schema and direct SQL documented |
| Review search UI/behavior | Jay | Real search verified, responsive, no fake results |
| Implement simple public page | Uday | Existing master page, accessible and responsive |
| Verify emergency request persistence | Zaid | Valid request persists; failure never shows false success |
| Write manual tests | Uday | Reproducible steps, expected/actual results and evidence |
| Review shared design tokens | Jay + Zaid | Consistent tokens, no unrelated regressions |

## Task template
Owner / Goal / In-scope files / Protected files / Dependencies / Acceptance criteria / Tests / Reviewer / Risks.

Discuss shared CSS, master pages, schema and auth before editing. Keep PRs small, report blockers early, and ensure anyone submitting AI-assisted code understands it.
