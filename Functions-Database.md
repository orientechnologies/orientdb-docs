---
search:
   keywords: ['functions', 'database']
---

# Database Functions

In previous exmaples, such as `factorial()`, the function is relatively self-contained.  It takes an argument from the query, operates on it, and returns the result.  This is useful in cases where you need to perform some routine arithmetic operation or manipulate strings in a consistent way, but you can also use functions to perform more complex database operations.  That is, the function can receive arguments, interact with the database, then return the results of that interaction.

## Database Variable

When you create a function, OrientDB always binds itself to the `orient` variable.  Using this variable you can call methods to access, query and operate on the database from the function.  The specific method called to access the database depends on the type of database you're using:

| Function | Description |
|---|---|
| `orient.getGraph()` | Retrieves the current [Transactional Graph Database]({{ book.javadoc }}/com/tinkerpop/blueprints/impls/orient/OrientGraph.html) instance |
| `orient.getGraphNoTx` | Retrieves the current [Non-transactional Graph Database]({{ book.javadoc }}/com/tinkerpop/blueprints/impls/orient/OrientGraphNoTx.html) instance |
| `orient.getDatabase()` | Retrieves the current [Document Database]({{ book.javadoc }}/com/orientechnologies/orient/core/db/document/ODatabaseDocumentTx.html) instance |

For instance, say you wanted a function to create the given user on the database.  You might create one that takes three arguments: `userName`, `passwd` and `roleName`.

```javascript
// Fetch Database
var db = orient.getDatabase();
var role = db.query("SELECT FROM ORole WHERE name = ?", roleName);

if (role == null){
	response.send(404, "Role name not found", "text/plain",
		"Error: Role name not found");
} else {
	db.begin();
	try {
		var result = db.save({"@class", name: userName, password: passwd,
			status: "ACTIVE", roles: role});
			db.commit();
			return result;
	} catch(err){
		db.rollback();
		response.send(500, "Error creating new user", "text/plain",
			err.toString());
	}
}
```

## Methods

As demonstrated in the example above, once you've retrieved the database interface, you can begin to call a series of additional methods to operate on the database from within the function.

| Method | Description |
|---|---|
| [**`addEdge()`**](Functions-Database-addEdge.md) | Adds edges to the graph |
| [**`addVertex()`**](Functions-Database-addVertex.md) | Adds vertices to the graph |
| [**`command()`**](Functions-Database-command.md) | Issues SQL command |
| [**`delete()`**](Functions-Database-delete.md) | Removes records |
| [**`getEdge()`**](Functions-Database-getEdge.md) | Retrieves edges |
| [**`getEdgeBaseType()`**](Functions-Database-getEdgeBaseType.md) | Retrieves the base class for edges, which is `E` by default |
| [**`getEdgeType()`**](Functions-Database-getEdgeType.md) | Retrieves the given edge class |
| [**`getVertex()`**](Functions-Database-getVertex.md) | Retrieves vertices |
| [**`getVertexBaseType()`**](Functions-Database-getVertexBaseType.md) | Retrieves the base class for vertices, which is `V` by default |
| [**`getVertexType()`**](Functions-Database-getEdgeType.md) | Retrieves the given edge class |
| [**`load()`**](Functions-Database-load.md) | Retrieves records |
| [**`query()`**](Functions-Database-query.md) | Queries the database |
| [**`removeEdge()`**](Functions-Database-removeEdge.md) | Removes edges from a graph |
| [**`removeVertex()`**](Functions-Database-removeVertex.md) | Removes vertices from a graph |

### Database Methods

| Method | Description |
|---|---|
| [**`open()`**](Functions-Database-open.md) | Opens the database |
| [**`close()`**](Functions-Database-close.md) | Closes the database |


### Class Methods

| Method | Description |
|---|---|
| [**`browseClass()`**](Functions-Database-browseClass.md) | Returns all records in a class |
| [**`countClass()`**](Functions-Database-countClass.md) | Counts records in given class |

### Cluster Methods

| Method | Description |
|---|---|
| [**`browseCluster()`**](Functions-Database-browseCluster.md) | Returns all records in a cluster |
| [**`dropCluster()`**](Functions-Database-dropCluster.md) | Removes cluster |
| [**`getClusterIdByName()`**](Functions-Database-getClusterIdByName.md) | Retrieves  the Cluster ID for the given cluster |
| [**`getClusterNameById()`**](Functions-Database-getClusterNameById.md) | Retrieves logical cluster name  |
| [**`getClusterNames()`**](Functions-Database-getClusterNames.md) | Retrieve cluster names |
| [**`getClusterRecordSizeById()`**](Functions-Database-getClusterRecordSizeById.md) | Retrieves the number of records in a cluster |
| [**`getClusterRecordSizeByName()`**](Functions-Database-getClusterRecordSizeByName.md) | Retrieves the number of records in a cluster |
| [**`getClusters()`**](Functions-Database-getClusters.md) | Retrieves clusters |

### Transaction Methods

| Method | Description |
|---|---|
| [**`begin()`**](Functions-Database-begin.md) | Initiates a transaction |
| [**`commit()`**](Functions-Database-commit.md) | Commits a transaction |
| [**`rollback()`**](Functions-Database-rollback.md) | Reverts a transaction |

### User Methods

| Method | Description |
|---|---|
| [**`getUser()`**](Functions-Database-getUser.md) | Retrieves the current user |
| [**`setUser()`**](Functions-Database-setUser.md) | Sets the user |
