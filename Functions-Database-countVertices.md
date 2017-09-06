---
search:
   keywords: ['functions', 'database', 'size', 'count',  'count vertex', 'count vertices', 'countVertices']
---

# Functions - countEdges()

This method counts the number of vertex records.

## Counting Records

On occasion you may find it useful to retrieve or reference the number of records in a database.  Using this method, you can count the number of vertex records in a database.  By default, it returns the records for the vertex base class `V`.  You can retrieve a count of records in subclasses of `V` by passing the class name as an argument.

### Syntax

```
var count = db.countVertices(<class>)
```

- **`<class>`** Defines the class you want to count.  Defaults to the base edge class, `V`.
