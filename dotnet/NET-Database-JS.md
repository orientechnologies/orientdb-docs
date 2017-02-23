---
search:
   keywords: ['NET', "C#", 'ODatabase', 'javascript', 'js']
---

# OrientDB-NET - `JavaScript()`

This method prepares JavaScript queries to execute on the OrientDB database.  The return value is an `OCommandQuery` object.

## Querying with JavaScript

In cases where you have database operations scripted in JavaScript, you can execute these through OrientDB-NET using the `JavaScript()` method.

### Syntax

```
OCommandQuery JavaScript(string <query>)
```

- **`<query>`** Defines the query to execute.

### Example

In cases situations where you prefer to operate on the database using JavaScript or would like to use features available through JavaScript but which are not yet available with OrientDB-NET, you can use this method to execute JavaScript from a string.

```csharp
using Orient.Client;
using System;

// RETRIEVE RECORDS FROM GIVEN CLASS
public OCommandResult FetchAllRecords(ODatabase database,
    string dbName, string className)
{
  // LOG OPERATION
  Console.WriteLine("Retrieving All Records: {0}",
    className);

  // CONSTRUCT SCRIPT
  string script = "
    var db = new ODatabase('http://localhost:2480/{0}');
    dbInfo = db.open();
    queryResult = db.Query('SELECT FROM {1}');
    db.close();
    return queryResult;",
    dbName, className);

  return database.JavaScript(script).Run();
}
```

In addition to building your JavaScript scripts from within your application as strings, you can also retrieve scripts from file.  You may find this particularly useful inc ases where you have a body of routine JavaScript operations already prepared for your application, or when you want to work with developers who are familiar with JavaScript, but somewhat less so with the C#/.NET framework.

```csharp
using Orient.Client;
using System;
...

// RUN JAVASCRIPT FILE
public OCommandResult JSQuery(ODatabase database, string filename)
{
  // LOG OPERATION
  Console.WriteLine("Run File: {0}", filename);

  // RETRIEVE SCRIPT
  string script = IO.File.ReadAllText(path);

  // RUN SCRIPT
  return database.JavaScript(script).Run();

}
```
