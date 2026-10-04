# Instructions for AI Coding Agents

Read this file and the developer guide before coding.

## Safety
1. Preserve existing functionality and data.
2. Never modify/push directly to `main`.
3. Work only on the explicitly assigned branch.
4. Do not create/delete branches unless requested.
5. Do not force-push, reset, rebase or rewrite shared history without approval.
6. Inspect actual files before claiming a page, table, feature or test exists.
7. Never invent page counts, schema, test results, testimonials or business claims.
8. Prefer focused changes over broad rewrites.

## Before coding
Inspect the solution, `.csproj`, target framework, master pages, markup, code-behind, configuration and data-access code. Read applicable docs, check branch/status, identify protected contracts, and plan multi-file work.

## Web Forms constraints
Preserve page directives, master-page relationships, content placeholders, IDs, `runat="server"`, validators, validation groups, event-handler names, postbacks and binding unless a coordinated change is approved. Do not convert to MVC, Razor Pages, ASP.NET Core or another framework. Do not rename solution/project files or namespaces without approval.

## Architecture and database
Prefer modest three-tier separation: presentation, business logic and data access. Introduce incrementally, not as a mass refactor. Use parameterized SQL, dispose ADO.NET resources, validate server-side, check authorization and never expose secrets/raw DB errors.

## UI
Follow `UI-UX-DESIGN-SYSTEM.md`. Reuse tokens; avoid duplicate CSS systems, fake functionality, dead controls, unsupported claims, unnecessary dependencies and decorative motion. Do not change business behavior as a side effect of visual redesign.

## Report honestly
Follow `TESTING-CHECKLIST.md`. Report only checks actually run. At completion list summary, exact files, behavior, commands/tests and results, manual tests still needed, risks and configuration/database changes. Do not commit/push unless requested and target branch is confirmed.
