---
search:
   keywords: ['java', 'odatabasedocument', 'load']
---

# ODatabaseDocument - load()

Loads a record by its Record ID.

## Loading Records

In situations where you want to access a record on the database and you know its specific Record ID, you may find it more convenient and performant to call the record up directly rather than retrieving it through a query.  Using this method you can fetch the record using an [`ORID`](../ORID.md) instance as an identifier.

You can also optionally define a [fetch plan](../../Fetching-Strategies.md) to define how OrientDB retrieves the record.

### Syntax

```
<RET extends T> RET ODatabaseDocument().load(ORID recordId)
<RET extends T> RET ODatabaseDocument().load(
   ORID recordId, 
   String fetchPlan)
```


