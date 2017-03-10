---
search:
   keywords: ['PHP', 'PhpOrient', 'query']
---

# PhpOrient - `query()`

This method issues an [SQL](SQL.md) query to the database.

## Querying the Database

In the event htat you're more comfortable working in SQL, you can build and issue queries to OrientDB directly using this method.

### Syntax

```
$client->query(<sql>)
```

- **`<sql>`** Defines the query you want to issue.

### Example

In cases where you find yourself frequently issuing queries to OrientDB, you may find it convenient to construnction a function to manage the process.

```php
// QUERY FUNCTION
function queryDatabase($className, 
			$properties = array('*'), 
			$whereCondtions = array(), 
			$limit = 0){

	// LOG OPERATION
	echo "Querying $className";

	// FETCH GLOBAL CLIENT
	global $client;

	// CONSTRUCT SELECT STATEMENT
	if ($properties == array('*')) {
		$sql = "SELECT FROM $classname";
	} else {
		$props = join(', ', $properties)
		$sql = "SELECT $prop FROM $classname";
	}

	// CONSTRUCT WHERE CLAUSE
	if ($whereConditions != array()){
		$where = "WHERE";

		// LOOP OVER CONDITIONS
		foreach($whereConditions as $property => $value){
			$where = "$where $property = \'$value\'";
		}

		// ADD WHERE TO STATEMENT
		$sql = "$sql $where";
	}

	// ADD LIMIT
	if ($limit > 0){

		// ADD LIMIT TO STATEMENT
		$sql = "$sql LIMIT $limit";
	}

	// QUERY DATABASE
	return $client->query($sql);
}
```



