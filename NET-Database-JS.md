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
