---
search:
   keywords: ['functions', 'database', 'size', 'count',  'count edges', 'countEdges']
---

# Functions - countEdges()

This method counts the number of edge records.

## Counting Records

On occasion you may find it useful to retrieve or reference the number of records in a database.  Using this method, you can count the number of edge records in a database.  By default, it returns the records for the edge base class `E`.  You can retrieve a count of records in subclasses of `E` by passing the class name as an argument.

### Syntax

```
var count = db.countEdges(<class>)
```

- **`<class>`** Defines the class you want to count.  Defaults to the base edge class, `E`.
