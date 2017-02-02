---
search:
   keywords: ["NET", 'C#', 'ODatabase', 'gremlin']
---

# OrientDB-NET - `Gremlin()`

This method executes [Gremlin](Gremlin.md) scripts.  The return value is an `OCommandResult` object.

## Executing Gremlin Scripts

In cases where you have existing scripts or would prefer to operate on OrientDB using the Gremlin language, you can do so through `ODatabase` interface, using the `Gremlin()` method.

### Syntax

```
OCommandResult Gremlin(string <query>)
```

- **`<query>`** Defines the command to execute

### Example

In situations where you prefer to using Gremlin scripts or would like to use features implemented in Gremlin but which are not yet available to OrientDB-NET, you can call these internally from a string.

```csharp
using Orient.Client;
using System;
...

// RETRIEVE VERTICES THROUGH GREMLIN
public OCommandResult fetchVertices(ODatabase database, string databaseName,
    string className)
{
  // LOG OPERATION
  Console.WriteLine("Gremlin Query: All Vertices in: {0}",
     className);

  // INITIALIZE SCRIPT
  string script = String.Format("
    g = new OrientGraph('plocal:/data/{0}');
    vertices = g.{1};
    g.close();
    return vertices;",
    databaseName, className);

  // EXECUTE SCRIPT
  OCommandResultSet resultSet = database.Gremlin(script);

  // RETURN RESULTS
  return resultSet;
}
```

In addition to building your Gremlin scripts within your application as strings, you can also retrieve the script from file.  You may find this particularly useful in cases where you have a body of routine Gremlin scripts already prepared for your application, or when you want to work with developers who are familiar with JavaScript and Gremlin, but somewhat less so with the C#/.NET framework.

```csharp
using Orient.Client;
using System;
...

// RUN GREMLIN SCRIPT FROM FILE
public OCommandResult runScript(ODatabase database, string path)
{
  // LOG OPERATION
  Console.WriteLine("Running Gremlin Script: {0}", path);

  // RETRIEVE SCRIPT
  string script = IO.File.ReadAllText(path);

  // RUN SCRIPT
  OCommandResult resultSet = database.Gremlin(script);

  // RETURN RESULT-SET
  return resultSet;
}
```
