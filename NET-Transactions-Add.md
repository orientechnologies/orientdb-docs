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
trx.Add<T>(T typedObject)
```

### Example

For instance, say that you have a business application that stores data on various accounts.  You might use something like this to add a new account to the database:

```csharp
// INITIALIZE NEW ACCOUNT
ODocument newAccount = ODocument()
   .SetField<string>("company_name", "Spam Productions, Ltd.")
   .SetField<string>("city", "Boston")
   .SetField<string>("state", "Massachusetts");

// ADD ACCOUNT TO TRANSACTION
trx.Add<ODocument>(newAccount);
```
