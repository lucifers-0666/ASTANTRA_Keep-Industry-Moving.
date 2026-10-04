# C# and ASP.NET Web Forms Coding Standards

- Prefer readable, explainable code and the language/framework version already configured.
- Use meaningful names and existing namespaces; avoid unrelated refactors and new dependencies without reason.
- Preserve page directives, master-page relationships, control IDs, `runat="server"`, validators, validation groups, handler names and postback behavior.
- Keep markup focused on presentation. Put event handlers in code-behind and call business logic instead of embedding SQL.
- Bind at the appropriate page lifecycle point; use `Page.IsPostBack` when needed to avoid lost input or repeated binding.
- Always validate server-side, even if client validation exists. Never disable request/event validation as a shortcut.
- Use parameterized SQL and dispose ADO.NET resources with `using` where supported.
- Never use empty catch blocks or show raw exception details to users. Do not log secrets, passwords or tokens.
- Check authorization on the server; hiding a button is not authorization.
- Never show success when a write failed. Encode untrusted output safely.
- Before commit, inspect `git diff`, `git diff --check`, changed files, warnings, secrets, generated output and local configuration. Commit only task-related files.
