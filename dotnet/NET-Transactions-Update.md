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

For instance, if you find yourself often updating records with complex information or changes made to multiple fields, you may find it useful to implement a helper function to simplify this process.

```csharp
using Orient.Client;
using System;
...

// UPDATE RECORDS
public void updateRecord(OTransaction trx, Dictionary<ODocument, Dictionary<string, string>> records)
{
   // LOG OPERATION
   Console.WriteLine("Update Records");

   // LOOP OVER DOCUMENTS
   foreach(KeyValuePair<ODocument, Dictionary<string, string>> record in records)
   {
      // INITILAIZE VARIABLES
      ODocument document = record.Key;
      Dictionary<string, string> fields = record.Value;

      // SET CHANGES
      foreach(KeyValuePair<string, string> field in fields)
      {
          // SET FIELD
          document.SetField<string>(field.Key, field.Value);
      }

      // APPLY CHANGES TO TRANSACTION
      trx.Update<ODocument>(document);
   }
}
``` 
