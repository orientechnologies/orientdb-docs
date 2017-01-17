---
search:
   keywords: ['NET', 'C#', 'ODatabase', 'command']
---

# OrientDB-NET - `Command()`

This method prepares or executes a command on the OrientDB database.  The return value is an `OCommandResult` object.

## Sending Commands

There are several methods available in issuing queries and commands to OrientDB through your C# application.  This method allows you to issue SQL commands to the database.

For information on available commands, see [SQL](SQL.md) and [Console](Console-Commands.md) commands.


### Syntax

```
// EXECUTING COMMANDS
OCommandResult Command(     string <query>)
```

- **`<query>`** Defines an SQL statement to execute.
- **`<command>`** Defines a prepared command object.

### Example

For instance, consider the use case of making internal data persistent across multiple operations.  When your application is running, it operates a dictionary object.  When it closes, it uploads data from the dictionary to OrientDB, so that it will have it ready when you run the app again.

```csharp
using Orient.Client;
using System;

// SAVE DATA
public void Save(ODatabase database, Dictionary<string, string> data)
{
   // LOG OPERATION
   Console.WriteLine("Saving Data to OrientDB");

   // LOOP OVER DATA
   foreach(KeyValuePair<string, string> entry in data)
   {
      // LOG OPERATION
      Console.WriteLine(" - Saving: {0}", entry.Key);

      // BUILD QUERY
      string sqlQuery = String.Format("UPDATE Save SET {0} = {1}",
         entry.Key, entry.Value);

      // RUN COMMAND
      database.Command(sqlQuery);
   }
}
```

Here, the application loops over the dictionary, running an [`UPDATE`](SQL-Update.md) statement for each variable in the data dictionary.
