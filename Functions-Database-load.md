---
search:
   keywords: ['functions', 'load']
---

# Functions - load()

This method retrieves the specified record from the database.

## Loading Records

When you have the [Record ID](Concepts.md#record-id) for a given record and want to retrieve it to operate on from your function, you can get it using this method and set it onto a variable.  It is comparable to [`getVertex()`](Functions-Database-getVertex.md) and [`getEdge()`](Functions-Database-getEdge.md) on graph databases.

### Syntax

```
var record = db.load(<rid>, <fetch-plan>, <cache>)
```

- **`<rid>`** Defines the Record ID.
- **`<fetch-plan>`** Defines the [Fetching Strategy](Fetching-Strategies.md) you want to use.  By default, method only fetches the given record.
- **`<cache>`** Defines whether you want to ignore cached result-sets.  By default, this is set to `false`.
