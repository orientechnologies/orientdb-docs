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

- Execute Gremlin scripts:

  ```csharp
  OCommandResult resultSet;
	string script = "
     g = new OrientGraph('plocal:/data/accounts');
     vertices = g.V;
     g.close();
     return vertices;";

  resultSet = database.Gremlin(script);
  ```

- Execute Gremlin scripts from file:

  ```csharp
  OCommandResult resultSet;
  string script = System.IO.File.ReadAllText("gremlin.js");

  resultSet = database.Gremlin(script);
  ```

