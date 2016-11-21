---
search:
   keywords: ['NET', 'C#', 'ODatabase', 'query']
---

# OrientDB-NET - `Query()`

This method issues SQL queries against the OrientDB database.  It returns a list of `ODocument` objects from the result-set.

## Querying the Database

### Syntax

```
// QUERY DATABASE
List<ODocument> Query(  string <SQL>)

// QUERY DATABASE WITH FETCH PLAN
LIst<ODocument> Query(  string <SQL>,
                        string <fetch-plan>)
```

- **`<SQL>`** Defines the SQL statement to use.
- **`<fetch-plan>`** Defines the [Fetching Strategy](Fetching-Strategies.md) to use.

### Example

queries
queries with fetch plans
prepared queries
