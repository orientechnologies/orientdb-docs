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

For instance, say that you have a web application and you would like to initialize a series of records when adding new users to the site.  You might loop through a dictionary to add these values:

```csharp
foreach(KeyValuePair<string, string> entry in insertDict)
{
   string sql = string.Format(
      "INSERT INTO {0} SET {1}",
      entry.Key,
			entry.Value,);

   database.Command(sql);
}
```

Here, the application loops over a dictionary with class-names as keys and insertions as values.  The key and values are then used to format an SQL command that is passed to the database.


