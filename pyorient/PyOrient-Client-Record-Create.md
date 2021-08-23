
# PyOrient Client - `record_create()`

This method creates a record on the open OrientDB database, using the given dict.

>**Warning**: Prior to version 2.0 of OrientDB, some users encountered issues with `record_create()` and [`record_update()`](PyOrient-Client-Record-Update.md) in PyOrient.  When developing applications for older versions of OrientDB, it is recommended that you avoid these methods.

## Creating Records

When you want to add a completely new record to the database, use the `record_create()` method.  This method takes two arguments, the ID of the cluster you want to add the data to, and a dict object that represents the data you want to add.

**Syntax**

```
client.record_create(<cluster_id>, <data>)
```

- **`<cluster_id>`** Integer that defnes the cluster to use.
- **`<data>`** Dict that defines the data to add.

The dict object you pass to this method uses the following format:

```
data = {
   @<class>: {
      <property>: <value>
   }
}
```

- **`<class>`** Defines the class name.
- **`<property>`** Defines the property you want to add, if any.
- **`<value>`** Defines the value you want to assign the property.


**Example**

For instance, consider the use case of a smart home database.  Your application is connected to several basic security devices set up around the exterior doors to your house.  Whenever someone approaches one of these doors, they trigger a motion sensor that initializes the event.

When setting up a system like this, you might want to record the event with webcams, log whether the visitor rang the doorbell, knocked or did nothing, and determine whether the interior or exterior locks were used in openning the door.  Once the application finishes recording the event, it needs to log the data to OrientDB, (such as an offsite server, in the event of burglary).


```py
event = {
   @DoorSecurityEvent: {
      "time_start": timestamp_start,
      "time_end": timestamp_end,
      "webcam_file": "/path/to/file.ogg,
      "doorbell": True,
      "knock": False,
      "open": True,
      "open_type": "InnerLock"
   },
}
client.record_create(cluster_id, event)
```

Here, your application records a postal service delivery.  It sets the cluster ID, as well as the starting and ending timestamp variables as they occur, then builds the dict object, then it passes the Cluster ID and the dict object to the `record_cluster()`, to log the delivery to OrientDB.
