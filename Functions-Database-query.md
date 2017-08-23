---
search:
   keywords: ['functions', 'database', 'query']
---

# Functions - query()

This method executes an OrientDB SQL query on the database.

## Querying from Functions

There are times when you may need to execute queries within your function.  For instance, if you need to check certain conditions on the database to determine what your function returns or you might want to use the function to perform some preprocessing operations before inserting records onto OrientDB.

### Syntax

```
var result = db.query(<sql>)
```

- **`<sql>`** Defines the OrientDB SQL command to execute.

