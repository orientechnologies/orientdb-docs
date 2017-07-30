---
search:
   keywords: ['MarcoPolo', 'Elixir', 'struct', 'fetch plan', 'fetching strategy', 'fetchplan']
---

# MarcoPolo - `FetchPlan`

This struct defines a [fetching strategy](Fetching-Strategies.md) for you to use queries.  It provides functions that you may find useful when traversing records.

## Working with Fetch Plans

Using the `FetchPlan` struct, you gain access to two additional functions: `resolve_links()` and `resolve_links!()`.  Each performs the same operation, however `resolve_links!()` raises an exception when it attempts to retrieve records that don't exist on the database.

### Syntax

```
# Resolve Links, ignore Exception if Record Not Found
resolve_links(<rids>, <linked>)

# Resolve Links, raise Exception if Record Not Found
resolve_links!(<rids>, <linked>)
```

- **`<rid>`** Defines a set of Record ID's, as [`MarcoPolo.RID`](MarcoPolo-RID.md) instances.
- **`<linked>`** Defines the document the given records link to, as a [`MarcoPolo.Document`](MarcoPolo-Document.md) instance.





