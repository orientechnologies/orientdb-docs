---
search:
   keywords: ['PHP', 'PhpOrient', 'ID', 'Record ID', 'Cluster ID']
---

# PhpOrient - `ID()`

This object provides an interface for operating on Record and Cluster ID's from within your PHP application.

## Working with ID's

Certain methods and objects in PhpOrient take Record or Cluster ID's as an argument.  In cases where you need to operate on these, use the `ID()` interface to generate the instance.  It also provides methods for constructing and abstracting the ID from the interface.

### Creating ID's

When creating a new instance of the `ID()` interface, there are a two approaches available to you: You can define the Cluster ID and Record ID using integers as arguments, or you can initialize the class without arguments as use the `parseString()` method to set the ID values from string.  For instance,

```php
// CREATE RID FROM INTEGERS 
$clusterID = 5;
$recordID = 3
$rid = new ID($clusterID, $recordID);

// CREATE ID FROM STRING
$stringID = "#5:3";
$rid = new ID().parseString($stringID); 
``` 

#### Using Cluster ID

In addition to these approaches, you can also partially instantiate an ID by only providing it with a Cluster ID.  For instance,

```php
$rid = new ID(5);
```

When you instantiate the `ID()` using this technique, it records the cluster you want to add the record to, but waits until you create the record on OrientDB before it sets the Record ID.  In cases where you're working with multiple client connections, such as in a web application, this can help to avoid conflicts where two clients attempt to create a record with the same Record ID.

### Retrieving Record ID

In cases where you want to extract the Record ID from a given `ID()` instance, for logging or other purposes, you can do so using the `__toString()` method.

```php
// CREATE RECORD ID
$id = new ID(5, 3);

// FETCH RECORD ID
$rid = $id->__toString();
```
