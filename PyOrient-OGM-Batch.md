---
search:
   keywords: ['PyOrient', 'Object Graph Mapper', 'OGM', 'batch']
---

# PyOrient OGM - Batch Operations

The Object-Graph Mapper provides basic support for transactions.  This allows you to group several operations together and execute them in a batch on the OrientDB database.  You may find this useful in ensuring concurrency as well as reducing the round-trip time on the given operation.

## Using Batch Transactions

Transactions in PyOrient use a similar workflow to transactions in OrientDB.  That is, you start by beginning the transaction, perform various operations as part of it, then commit those changes to the database.


### Initializing Batch Transactions

Unlike standard operations with the OGM, batch transactions operate on a separate object from the OGM `Graph` class.  Instead, you use the `batch()` method to initialize a control object for the transaction.  You can then direct operations on OrientDB through this object, only committing it to OrientDB when you're ready.

```py
# Initialize Batch Transaction
batch = graph.batch()
```

### Performing Operations

Once you've initialized the control object through the `batch()` method, you can begin building the transaction.  For instance, consider the example of a smart home application that uses OrientDB for back-end storage.  While home built systems often have the database server on premises, let's say that you expect some homes to rely on a remote database accessed through the internet.

In situations like this, database initialization can prove difficult, since it would involve multiple network requests to OrientDB.  Instead you can group this process into a batch transaction handled through a single network operation.


#### Initialize Classes

In preparing a batch operation to initialize the database, you might start by initializing the classes that you want to create:

```py
# Initialize Sensor Class
class Sensor(Node):
   element_type = 'sensor'
   element_plural = 'sensors'

   name = String(multibyte = False, unique = True)
   node_type = String(multibyte = False)

# Initialize Zone Class
class Zone(Node):
   element_type = 'zone'
   element_plural = 'zones'

   name = String(multibyte = False, unique = True)
   zone_type = String(multibyte = False)

# Initialize Position Class
class SensorPosition(Relationship):
   label = 'position'
```

Here, you create three classes: two vertex classes for sensors and zones in the house, and an edge class for to position the sensors in particular zones.  The special attribute `element_type` is redundant here, but it allows you to tell the mapper what name to use for the corresponding schema class.


#### Creating Vertices

With the classes created, you can create particular instances of these classes, then adding them to the batch transaction:

```py
# Create Pollen Sensor
batch['pollen-sensor-1452'] = batch.sensors.create(
   name = 'ARDUINO-UNO-1432', 
   node_type = 'pollen')

# Create Light Sensor
batch['light-sensor-259'] = batch.sensors.create(
   name = 'ARDUINO-UNO-259',
   node_type = 'light-sensor')

# Create Bedroom Zone
batch['master-bedroom'] = batch.zones.create(
   name = 'master',
   zone_type = 'bedroom'
```

This creates three vertices in the batch: one for an Arduino device built as a pollen sensor, one for a light sensor,  and one for a zone for the master bedroom.  

#### Creating Edges

With the vertices created, you can also create edges to connect them.  In doing so, you have the option of two syntax methods for the operation.

```py
# Place Pollen Sensor (Method 1)
batch[:] = batch.position.create(
   batch[:'pollen-sensor-1452'],
   batch[:'master-bedroom']).retry(20)

# Place Light Sensor (Method 2)
batch[:] = batch[:'light-sensor-259'](SensorPosition) > batch[:'master-bedroom']
```

In the example, notice that in both cases the code defines the relationship using slice syntax.  You can do this in cases where you don't need to reference the edge later in the batch transaction.


#### Return Values

In the event that you would like to perform further operations on the code before committing the transaction, batches provide an optional return value.  You can retrieve this value from the control object:

```py
# Fetch Pollen Sensor Return Value
pollen = batch['$pollen-sensor-1452']
```

This retrieves the return value and sets it on the `pollen` variable.


### Committing Batch Transactions

When you're finished with the batch transaction, you can commit it to OrientDB using the `commit()` method.

```py
# Cmmmit Batch Transaction
batch.commit()
```

When you issue this method, PyOrient sends a network request to OrientDB, then executes each operation in the batch through that single request, without the need for the usual back and forth between the two.
