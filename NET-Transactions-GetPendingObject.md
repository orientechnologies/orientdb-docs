---
search:
   keywords: ['C#', 'c sharp', 'NET', 'transaction', 'GetPendingObject']
---

# OrientDB-NET - `GetPendingObject<T>()`

This method returns objects from a transaction.

## Retrieve Pending Objects

In cases where you need to operate on particular records already added to a transaction, you can use `GetPendingObject<T>()` to retrieve it.

### Syntax

```
T trx.GetPendingObject<T>(ORID rid)
```
- **`rid`** Defines the Record ID that you want to retrieve.

### Example

For instance, say you want to retrieve a vertex from a transaction:

```csharp
public OVertex fetchVertex(OTransaction trx, ORID rid)
{
   // FETCH VERTEX
   OVertex target = trx.GetPendingObject<OVertex>(rid);
   return target;
}
```

