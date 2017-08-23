---
search:
   keywords: ['functions', 'delete']
---

# Functions - delete()

This method removes the given record from the database.

## Removing Records

OrientDB provides an SQL command called [`DELETE`](SQL-Delete.md)to remove records from the database.   However, sometimes you may want to do something a little more dynamic than simple deletion.  For instance, a conditional deletion, where the record is only removed when certain conditions in other records are met.

### Syntax

```
db.delete(<rid>)
```

- **`<rid>`** Defines the [Record ID](Concepts.md#record-id).
