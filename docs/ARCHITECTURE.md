# Application Architecture

## Baseline
ASP.NET Web Forms, C#, SQL Server/ADO.NET. Inspect the solution and `.csproj` to verify exact target framework, namespaces, configuration keys and schema. Do not upgrade frameworks as part of routine feature work.

## Preferred three-tier architecture
1. **Presentation:** `.aspx`, master pages and code-behind event handlers.
2. **Business logic:** C# classes for business rules, validation and use-case orchestration.
3. **Data access:** C# classes for parameterized SQL, ADO.NET and result mapping.

SQL Server is the database, not a fourth tier.

```text
Browser -> Web Forms page -> code-behind -> business service -> data-access class -> SQL Server
Browser <- safe UI result <- business result <- mapped data/error <---------------------------
```

Keep markup focused on presentation. Code-behind handles page lifecycle, events and binding; business classes enforce rules; data-access classes execute parameterized SQL and map results. Avoid large SQL commands in page event handlers and avoid overengineering.

Introduce the architecture incrementally: inspect the existing feature, add/reuse the smallest suitable classes, update that page, test success/invalid input/database failure, then remove duplicated old logic only when the replacement is verified. Do not change schema, auth behavior, session keys or connection-string names without approval.

Adapt folder structure to the actual `.csproj`; do not add `App_Code` or reorganize the whole project without checking how it compiles. Never expose stack traces, SQL errors, credentials or internal paths. Use least-privilege credentials and server-side authorization.
