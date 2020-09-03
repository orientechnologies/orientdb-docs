---
search:
   keywords: ['PyOrient', 'client', 'batch']
---

# PyOrient Client - `batch()`

This methods allows you to execute a series of SQL commands as a [batch](../sql/SQL-batch.md) operation.

## Executing Batch Operations

Normally, when you execute a series of commands in PyOrient, the operations are run in sequence.  If your application is connecting to a remote server, this means that the PyOrient client is connecting over the network for each commands, which can introduce latency issues for your application.

Batch operations allow you to group several commands together, then issue them together in a single operation.

**Syntax**

```
client.batch(<batch>)
```

- **`<batch>`** Defines the batch commands.

**Example**

Consider the example of a smart home system that uses OrientDB as its back-end database.  You have created and installed various environmental sensors around the house.  Every fifteen minutes, your applications takes readings from these sensors and adds them to the database.  Given that there may be several dozen sensors in the house, you may find it advantageous to update OrientDB through a batch operation.

```py
# Initialize Batch Commands Array
batch_cmds = ['begin']

# Set Time
time_now = time.now()

# Add Commands to Array
for sensor in sensors:
   node = sensor.node
   zone = sensor.zone
   read = read_sensor(sensor)
   command = ("let %s = CREATE VERTEX Node"
              "SET node ='%s', zone = '%s',"
	      "read = '%s', time = '%s"
	      % (node, node, zone, time_now, read))
   batch_cmds.append(command)

# Add Batch Commit
batch_cmds.append('commit retry 100;')

# Join with Semicolons
cmd = ';'.join(batch_cmds)

# Execute Commands
results = client.batch(cmd)
```

Here, you have an array of record objects for each sensor in the house.  Iterating over that array, you extract the node name and zone, then take a reading from the sensor and use it in defining a [`CREATE VERTEX`](../sql/SQL-Create-Vertex.md) batch command.  Once you have a command for each sensor, it joins the batch commands with a commit message, creating a string object to pass to `batch()`.


