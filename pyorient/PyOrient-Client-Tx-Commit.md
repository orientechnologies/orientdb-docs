---
search:
   keywords: ['PyOrient', 'client', 'transaction']
---

# PyOrient Client - `tx_commit()`

This method initializes a transaction control object.

## Working with Transactions

Transactions represent units of work executed against the database, which are treated in a coherent and reliable way, independent of other transactions.  They provide units of work, allowing for failure recovery and keeping the database consistent even in cases of system failure.  They also provide isolation in cases where multiple clients concurrently access the database.

In PyOrient, the `tx_commit()` client method initializes a transaction control object.  Using the control object, you can begin and operate on the transaction itself, controlling what gets added and when the application commits the changes.

**Syntax**

```
client.tx_commit()
```

**Examples**

Consider the example of a smart home system that uses OrientDB for its back-end storage.  Say that you have a web application that runs on a touchscreen device built into or near the refrigerator.  This application allows you to create and update grocery lists.  Other applications can then call up the grocery list to automatically send SMS reminders about things family members need to pick up on their next trip to the supermarket.

The grocery list application handles updates using transactions, beginning the transaction when the user edits the list and committing it after they save.  For instance, your application may build a transaction update like this,

```py
# Define Cluster
cluster_id = 3

#  Create Record for Base Objects
record_base = {
   'store': "Davis Square Farmers' Market",
   'list': [],
}
record_position = client.record_create(cluster_id, record_base)

# Begin Transaction
tx = client.tx_commit()
tx.begin()


# Create Record in Transaction
record_1 = {
   'store': "McKinnon's Meat Market",
   'list': ['steak', 'eggs', 'sausage']
}
new_record = client.record_create(-1, record_1)

# Update Existing Record
record_2 = {
   'store': "Davis Square Farmers' Market",
   'list': ['garlic, 'green pepper', 'onion', 'celery'],
}
update_record = client.record_update(
      cluster_id, 
      record_position._rid,
      record_2,
      record_position._version
)

# Attach Operations to Transaction
tx.attach(new_record)
tx.attach(update_record)

# Commit the Transaction
results = tx.commit()

assert results["#3:1"].store == "Davis Square Farmers' Market"
assert results["#3:2"].store == "McKinnon's Meat Market"
```
