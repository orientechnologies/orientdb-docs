---
search:
   keywords: ['C#', 'c sharp', 'NET', 'transaction', 'add', 'update', 'AddOrUpdate']
---

# OrientDB-NET - `AddOrUpdate<T>()`

This method adds a new record to the database.  In the event that the record already exists, it updates the record with new data. 

## Adding or Updating Records

In deployments where there is the risk of the database changing while the transaction is open or where you are uncertain if a class exists on the database, you can call the `AddOrUpdate()` method to add a new record or update an existing one, depending on whether or not the record exists already on the database.

### Syntax

```
OTranasction.AddOrUpdate<T>(T target)
```

- **`target`** Defines the object you want to add or update on the database.  It is of the type defined by the generic.


### Example

For instance, if you find yourself often adding or updating records with complex, but routine, ifnromation, you may find it useful to implement a helper function to simplify these operations.

```csharp
using Orient.Client;
using System;
...

// ADD OR UPDATE TRANSACTION
public void TrxUpdate(OTransaction trx, Dictionary<ORID, Dictionary<string, string>> records)
{
   // LOG OPERATION
   Console.WriteLine("Updating Records in Transaction");

   // LOOP OVER RECORDS
   foreach(KeyValuePair<ORID, Dictionary<string, string>> record in records)
   {
      // LOAD RECORD
      ODocument document = LoadRecord().ORID(record.Key);

      // DEFINE FIELDS
      foreach(KeyValuePair<string, string> field in record.Value)
      {
          // SET FIELD
          document.SetField<string>(field.Key, field.Value);
      }

      // ADD OR UPDATE RECORD
      trx.AddOrUpdate<ODocument>(document);
   }
}
```
