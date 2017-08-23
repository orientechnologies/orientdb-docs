---
search:
   keywords: ['functions', 'command']
---

# Functions - command()

This methods issues an OrientDB SQL command to the database.

## Issuing Commands

Using this method, you can issue OrientDB SQL commands to the database from within your function.  You can also pass parameters with the command string to dynamically set variables.

### Syntax

```
var results = db.command(<sql>, [<param>, ...])
```

- **`<sql>`** Defines the OrientDB SQL command.
- **`<param>`** Defines parameters to substitute in the command, (if any).
