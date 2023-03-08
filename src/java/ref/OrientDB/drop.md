
# OrientDB - drop()

This method removes a database from the OrientDB Server.

## Dropping Databases

On occasion, you may need to remove databases from within your application.  For instance, as part of a maintenance application, or to remove temporary in-memory databases when they're no longer needed.

### Syntax

```
public void OrientDB().drop(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database name |


### Example

Imagine an application that makes use of in-memory databases to perform complex operations.  Whenever you need one for a specific task, you create it, run the process, then remove the database once the job is complete.

```java

public void runInMemOperation(String name){

	// Log Operation
	logger.info("Creating In-Memory Database");

	orientdb.create(name, ODatabaseType.MEMORY);

	try {
	   // Your Code Here
	   ...

    } finally {
       // Remove Database When Done
	   orientdb.drop(name);

   }
}
```
