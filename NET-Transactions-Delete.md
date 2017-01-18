---
search:
   keywords: ['C#', 'c sharp', 'NET', 'transaction', 'delete']
---

# OrientDB-NET - `Delete<T>()`

This method is used to remove records from the database.  Define the type through the generic.

## Removing Records

In certain situations you may want to programmatically remove records from OrientDB.  Using the `Delete<T>()` method you can remove the instance as part of a transaction.

### Syntax

```
OTransaction.Delete<T>(T typedObject)
```
- **`typedObject`** Defines the object you want to remove.  The object must be of the same type as defined in the `T` generic.

### Example

For instance, say that you want to create a function for removing records from the database.

```csharp
public void removeDocument(OTransaction trx, ODocument document)
{
   // REMOVE RECORD
   trx.Delete<ODocument>(document);
}
```
