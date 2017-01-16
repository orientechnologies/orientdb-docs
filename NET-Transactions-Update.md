---
search:
   keywords: ['C#', 'c sharp', 'NET', 'update', 'transaction']
---

# OrientDB-NET - `Update<T>()`

This method allows you to update records as part of a transaction.

## Updating Records

Using this method you can update records that already exist in the database as part of a transaction.  This way you can evaluate the changes before committing them to the database.

### Syntax

```
void trx.Update<T>(T typedObject)
```

- **`typedObject`** Defines the object you want to update.

### Example

For instance, you might create a method on a class to handle update functions, matching them to an open transaction managed by that class.

```csharp
public void updateAccount(ODocument document)
{
   // UPDATE RECORD
   trx.Update<ODocument>(document);
}
``` 
