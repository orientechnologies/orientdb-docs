---
search:
   keywords: ['C#', 'NET', 'c sharp', 'transaction']
---

# OrientDB-NET - OTransaction

Transactions allow you to organize a series of commands on the database into units of work.  Once you have done the work that you want to do, you can then commit the transaction to the database to make it persistent or revert the database to an earlier state.

In OrientDB-NET, tranasctions are controlled through the `OTransaction` object, which you can access through the [`ODatabase`](NET-Database.md) interface.

For more information, see [Transactions](Transactions.md).

## Initialize a Transaction 

In order to initialize a transaction, you need to first create a transaction object to manage and identify the changes you are making.  This is handled through the database interface.

```csharp
OTransaction trx = ODatabase.Transaction;
```

This initializes an `OTransaction` object that you can then use in further operations, building the transaction before you commit it to the database.

## Working with Transactions

Once you have the `OTransaction` interface initialized, you can call methods on this object to build the transaction.  These are similar to the methods you would normally call on the `ODatabase` interface, but specific to the transaction.

| Method | Description |
|---|---|
| [`Add<T>()`](NET-Transactions-Add.md) | Adds an object, typed by the generic. |
| [`AddEdge()`](NET-Transactions-AddEdge.md) | Adds an edge. |
| [`AddOrUpdate<T>()`](NET-Transactions-AddOrUpdate.md) | Adds a new object or updates an existing one. |
| [`Commit()`](#commit) | Commits changes made in the transaction to the database. |
| [`Delete<T>()`](NET-Transactions-Delete.md) | Removes a record. |
| [`GetPendingObject<T>()`](NET-Transactions-GetPendingObject.md) | Retrieves last object of the given type in the transaction.|
| [`Reset()`](#reset) | Closes the transaction and reverts all changes made to it. |
| [`Update<T>()`](NET-Transactions-Update.md) | Updates records on the database. |


## `Commit()`

When you make changes to the database through an `OTransaction` object, these changes are not persistent.  In order to make them persistent, you need to commit your changes to the database.  Or, in the event that you aren't happy with the changes, you can revert the database to an earlier state, that is the state of the last commit or before you opened the transaction.

To commit your changes to the database, call the `Commit()` method on the transaction.

```csharp
// COMMIT TRANSACTION
trx.Commit();
```

All changes made on the transaction are now committed to the database.


## `Reset()`

When you make changes on the database that you are not happy with, such as in cases where there's a problem or issue with the database state, you can roll the data back to an earlier state by calling the `Revert()` method on the transaction.

```csharp
// REVERT CHANGES ON TRANSACTION
trx.Revert();
```

All changes made on the transaction are removed.  The database reverts to its earlier state.
