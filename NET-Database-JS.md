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

- Executing JavaScript operation:

  ```csharp
  OCommandQuery resultSet;
  string script = "
     var db = new ODatabase('http://localhost:2480/accounts');
     dbInfo = db.open();
     queryResult = db.query('SELECT FROM Account');
     db.close()
     return queryResult;

  resultSet = database.JavaScript(script);
  ```

- Execute JavaScript from file:

  ```csharp
  OCommand resultSet;
  string script = System.IO.ReadAllText("query.js");

  resultSet = database.JavaScript(script);
  ```



