---
search:
   keywords: ['c#', 'c sharp', 'NET', 'transaction', 'add']
---

# OrientDB-NET - `Add<T>()`

This method adds records to the database.  The new records remain part of the transaction and can either be removed or made persistent, through [`Commit()`](NET-Transactions.md#commit) or [`Revert()`](NET-Transactions.md#revert).

## Adding Records

In order to add records to the database, you need to initialize the objects and then pass them to the `Add<T>()` method.

### Syntax

```
OTransaction.Add<T>(T typedObject)
```

### Example

For instance, if you find yourself often adding records with complex information or changes made to multiple fields, you may find it useful to implement a helper function to simplify these operations. 

```csharp
using Orient.Client;
using System; 
...

// ADD RECORDS TO THE DATABASE
public void AddRecords(OTransaction trx, List<Dictionary<string, string>>	records)
{
   // LOG OPERATION
   Console.WriteLine("Adding Records to Transaction");

   // LOOP OVER NEW RECORDS LIST
   foreach(Dictionary<string, string> record in records)
   {
      // INITIALIZE RECORD
      ODocument document = ODocument();

      // DEFINE RECORD CONTENTS
      foreach(KeyValuePair<string, string> field in record)
      {
         // DEFINE FIELD
         document.SetField<string>(field.Key, field.Value);
      }
      
      // ADD TO RECORD TO TRANSACTION
      trx.Add<ODocument>(document);
   }

}
```
