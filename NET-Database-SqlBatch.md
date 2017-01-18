---
search:
   keywords: ['NET', 'C#', 'ODatabase', 'batch', 'SqlBatch']
---

# OrientDB-NET - `SqlBatch()`

This method prepares a [`Batch`](SQL-batch.md) command.  The return value is an `OCommandQuery` object.

## Executing Batch Commands

OrientDB supports scripting arbitrary commands through a minimal SQL engine to batch commands together.  Using `SqlBatch()` command, you can execute these scripts from within your C#/.NET application.

### Syntax

```
OCommandQuery ODatabase.SqlBatch(string command)
```

- **`command`** Defines the command you want to execute.

### Example

For instance, say you have a business application that tracks accounts in different regions and sales persons assigned to that region.  Whenever someone joins the team, you need to update OrientDB to tell the application who they are and their assigned region.

```csharp
public AddToSales(ODatabase database, string name, string region)
{
   string query = string.Format("begin
      let region = select from Region where name = {0}
      let employee = create vertex Sales set name = '{1}'
      let e = create edge Assignment from $employee to $account
      commit retry 100
      return $e", region, name);

   return database.SqlBatch(query);
}
```
