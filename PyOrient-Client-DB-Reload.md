---
search:
   keywords: ['PyOrient', 'client', 'reload database']
---

# PyOrient Client - `db_reload()`

This method reloads the open database, refreshing cluster information from OrientDB.

## Reloading Databases

On occasion, you may encounter or implement deployments where multiple clients are interacting with the OrientDB server at a given time.  In cases such as this, you may need to reload the database, updating cluster information on the `client` object.

**Syntax**

```
client.db_reload()
```

**Example**

For instance, consider the example of the smart home application database.  You have a web interface that provides control functionality and a back-end systems that update the database with information taken from physical devices.  Periodically, you may need the web interface to reload its client connection.  

```py
class WebInterface():

   def __init__(self, client):
      self.client = client

   def reload(self):
      self.client.db_reload()
``` 

Here, the class receives the PyOrient Client and initializes it as a class variable.  You can then periodically call the method periodically to reload the database on the client, updating cluster information.
