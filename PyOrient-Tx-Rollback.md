# PyOrient Transactions = `rollback()`

This method rolls the database back to an earlier state, removing any changes made on the open transaction.

## Rolling Back Transactions

When you initialize a transaction through the [`tx_commit()`](PyOrient-Client-Tx-Commit.md) client method, the return object provides you with several methods used in controlling the transaction process.  Using the `rollback()` method, you can close the transaction, reverting all associated changes made to the database.

**Example**

For instance, say for a web application you want to create a series of new records on the database through a transaction.  This ensures that, in the event that something goes wrong in the process, you can revert the database to its earlier state rather than committing an incomplete operation.

```py
# Initialize Transaction Control Object
tx = client.tx_commit()

# Begin Transaction
tx.begin()

try:
   # Create Records
   for record in records:
      new = client.record_create(cluster_id, record)
      tx.attach(new)
except:
   tx.rollback()

# Commit Changes
tx.commit()
```

Here, your application has an array of records stored in the `records` object.  It initializes a transaction object with the [`tx_commit()`](PyOrient-Client-Tx-Commit.md) client method, then begins the transaction with [`begin()`](PyOrient-Tx-Begin.md).  Within a `try` statement, it loops through this array, using the [`record_create()`](PyOrient-Client-Record-Create.md) method to create new records.  After it creates the record, it attaches the operations to the open transaction.

In the event that there is a problem, Python executes the `except` statement, which calls `rollback()`, reverting the database to its earlier state.  If it's able to create all the records in the array, it issues the [`commit()`](PyOrient-Tx-Commit.md) method to commit the changes to the database.
