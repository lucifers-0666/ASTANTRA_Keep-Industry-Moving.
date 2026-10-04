# SQL Server and ADO.NET Standards

Preferred flow: `Web Forms page -> Business service -> Data-access class -> SQL Server`. Introduce incrementally and inspect the actual schema; do not assume tables or columns exist.

- Parameterize all user input. Never concatenate user values into SQL.
- Follow the existing ADO.NET conventions and dispose connections, commands and readers correctly.
- Open connections as late as practical and close promptly.
- Select only needed columns; explicitly list columns in INSERT/UPDATE.
- Use appropriate data types, constraints, keys and transactions for multi-step operations.
- Check affected-row counts where useful and handle constraint/timeout failures safely.
- Never show raw SQL exceptions or claim data was saved before the write succeeds.
- Reuse the actual configured connection-string key; never hard-code credentials or commit secrets. Use least-privilege credentials.
- Schema changes require a reason, repeatable SQL/migration, impact analysis, test cases and recovery notes.

Illustrative example only; `Parts` is hypothetical and must be checked against the real schema:

```csharp
using (SqlConnection connection = new SqlConnection(connectionString))
using (SqlCommand command = new SqlCommand(
    "SELECT PartId, PartName FROM Parts WHERE PartName LIKE @Search", connection))
{
    command.Parameters.Add("@Search", SqlDbType.NVarChar, 100)
        .Value = "%" + searchTerm + "%";
    connection.Open();
    // Read/map results using the existing project pattern.
}
```
