---
search:
   keywords: ['NET', 'C#', 'ODatabase', 'command']
---

# OrientDB-NET - `Command()`

This method prepares or executes a command on the OrientDB database.  The return value is either an `OCommandResult` or `PreparedCommand` object.

## Sending Commands

### Syntax

```
// EXECUTING COMMANDS
OCommandResult Command(     string <query>)
```

- **`<query>`** Defines an SQL statement to execute.
- **`<command>`** Defines a prepared command object.

### Example
