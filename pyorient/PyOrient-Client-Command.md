---
search:
   keywords: ['PyOrient', 'command']
---

# PyOrient Client - `command()`

This method allows you to issue SQL commands to an open OrientDB database.

## Sending Commands

There are several methods available in issuing queries and commands to OrientDB.  Using the `command()` method calls the `OCommandSQL` Java class in OrientDB.  This allows you issue commands to OrientDB through your application as you would from the Console.

**Syntax**

```
client.command(<sql-command>)
```

- **`<sql-command>`** Defines the command you want to issue.

**Example**

Going back to the example of a smart home database, consider the use case of logging environmental information to the database for later analysis.  In each room in your house, you set up a series of small Arduino devices to monitor light, sound levels, pollen count and so on.  Every fifteen minutes, your application needs to pull data off each device and log on the database for later graphing and analysis. 

```py
for sensor in pollen_sensors:
	 client.command(
      "INSERT INTO PollenSensor "
      "('device_id', 'read_time', 'read') "
      "VALUES('%s', '%s', %s')"
      % (sensor.get_id()
         time.now(),
         sensor.get_data()))
```

Here, the application iterates through an array of pollen sensors.  For each entry, it issues an [`INSERT`](../sql/SQL-Insert.md) statement to OrientDB, retrieving the identifier and data from the sensor object and using the Python `time` module to timestamp the entry.

