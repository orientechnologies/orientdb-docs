
# PyOrient Transactions - `attach()`

This method attaches operations to particular transactions.

## Attaching Operations

When you initialize a transaction through the [`tx_commit()`](PyOrient-Client-Tx-Commit.md) client method, the return object provides you with several methods used in controlling the transaction process.  Using the `attach()` method, you can associate various client operations with the transaction.

You can then call [`commit()`](PyOrient-Tx-Commit.md) to apply the changes to OrientDB.  In the event that you aren't satisfied with the changes, you can revert the database to an earlier state by calling [`rollback()`](PyOrient-Tx-Rollback.md).

**Syntax**

```
tx.attach(<record>)
```

- **`<record>`** Defines the PyOrient return object for a database operation you want to add to the transaction.  For instance, the return object for the [`record_create()`](PyOrient-Client-Record-Create.md) or [`record_update`](PyOrient-Client-Record-Update.md) client methods.

**Example**

Consider the example of a smart home system that uses OrientDB for back-end storage.  Say that your application uses the database to store configuration options, such as how often to take readings from environmental sensors or where it should stream the video feed from security cameras. 

```
# Prepare Update
updated_config = {
"sensorReadInterval": 15
}
update = client.record_update(cluster_id, '#2:1', updated_config)

# Attach to Transaction
tx.attach(update)
```

Here, the configuration record, (that is, #2:1), is updated with a new value assigned to the `sensorInterval` property.  When you commit the transaction, it updates the interval on environmental sensors to take readings every fifteen minutes.
