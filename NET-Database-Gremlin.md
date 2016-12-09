---
search:
   keywords: ["NET", 'C#', 'ODatabase', 'gremlin']
---

# OrientDB-NET - `Gremlin()`

This method executes Gremlin scripts.  The return value is an `OCommandResult` object.

## Executing Gremlin Scripts

In cases where you have existing scripts or would prefer to oprate on OrientDB using the Gremlin language, you can do so through `ODatabase` interface, using the `Gremlin()` method.

### Syntax

```
OCommandResult Gremlin(string <query>)
```

- **`<query>`** Defines the command to execute

### Example

