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
trx.AddOrUpdate<T>(T target)
```

- **`target`** Defines the object you want to add or update on the database.  It is of the type defined by the generic.


### Example

For instance, say that you have a business application that stores data on various client accounts.  You might create a method to add new accounts to the database, which will update them in the event that the account exists already.

```csharp
// ADD ACCOUNT TO DATABASE
public void AddAccount(string name, string city, string state)
{
   // INITIALIZE DOCUMENT
   ODocument company = ODocument()
      .SetField<string>('name', name)
      .SetField<string>('city', city)
      .SetField<string>('state', state);

   // ADD TO TRANSACTION
   trx.AddOrUpdate<ODocument>(company);
}
```
