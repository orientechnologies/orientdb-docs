# SQL - UPDATE

Update one or more records in the current database. Remember that OrientDB can work also in schema-less mode, so you can create any field on-the-fly. Furthermore, OrientDB works on collections. This is the reason why OrientDB SQL has some extensions to handle collections.

## Syntax

```sql
UPDATE <class>|cluster:<cluster>|<recordID>
  [SET|INCREMENT|ADD|REMOVE|PUT <field-name> = <field-value>[,]*]|[CONTENT|MERGE <JSON>]
  [UPSERT]
  [RETURN <returning> [<returning-expression>]]
  [WHERE <conditions>]
  [LOCK default|record]
  [LIMIT <max-records>] [TIMEOUT <timeout>]
```

Where:
- **SET** updates the field
- **INCREMENT** increments the field by the value. If the record had 10 as a value and "INCREMENT value = 3" is executed, then the new value will be 13. This is useful for atomic updates of counters. Use negative numbers to decrement. INCREMENT can be used to implement [sequences](Sequences-and-auto-increment.md) (autoincrement) 
- **ADD**, adds a new item in collection fields
- **REMOVE**, removes an item in collection and maps fields
- **PUT**, puts an entry into map fields
- **CONTENT**, replaces the record content with a JSON
- **MERGE**, merges the record content with a JSON
- **LOCK** specifies how the record is locked between the load and the update. It can be a value between:
 - *DEFAULT*, no lock. In case of concurrent update, the MVCC throws an exception
 - *RECORD*, locks the record during the update
- **UPSERT** updates a record if it already exists, or inserts a new record if it does not, all in a single statement. This avoids the need to execute 2 commands, one for the query and a conditional insert/update. UPSERT requires a WHERE clause and a class target. There are limitation on usage of UPSERT. See below.
- **RETURN** specifies what to return as ```<returning>```. If ```<returning-expression>``` is specified (optional) and returning is BEFORE or AFTER, then the expression value is returned instead of record. ```<returning>``` can be a value between:
 - **COUNT**, the default, returns the number of updated records
 - **BEFORE**, returns the records before the update
 - **AFTER**, returns the records after the update
- WHERE, [SQL-Where](SQL-Where.md) condition to select records to update
- LIMIT, sets the maximum number of records to update
- TIMEOUT, if any limits the update operation to a timeout

Note that [RecordID](Concepts.md#recordid) must be prefixed with '#'. Example: #12:3.

To know more about conditions, take a look at [WHERE conditions](SQL-Where.md).

## Limitation on usage of UPSERT clause
UPSERT guarantee the atomicity only if a UNIQUE index is created and the lookup on index is done by where condition. 

In this example a unique index on Client.id must be present to guarantee uniqueness on concurrent operations:
```sql
UPDATE client SET id = 23 UPSERT WHERE id = 23
```
## Examples

### Example 1: Change the value of a field
```sql
UPDATE Profile SET nick='Luca' WHERE nick IS NULL

Updated 2 record(s) in 0,008000 sec(s).
```

### Example 2: Remove a field from all the records
```sql
UPDATE Profile REMOVE nick
```

### Example 3: Add a value into a collection
```sql
UPDATE Account ADD addresses=#12:0
```
>Note: in OrientDB server version 2.0.5 you will generate a server error if there is no space between the # and =. The command needs to be

```sql
UPDATE Account ADD addresses = #12:0
```

### Example 4: Remove a value from a collection

If you know the exact value you want to remove:

Remove an element from a link list/set
```sql
UPDATE Account REMOVE addresses = #12:0
```

Remove an element from a list/set of strings
```sql
UPDATE Account REMOVE addresses = 'Foo'
```

Filtering on value attributes:

Remove addresses based in the city of Rome
```sql
UPDATE Account REMOVE addresses = addresses[city = 'Rome']
```

Filtering based on position in the collection:

Remove the second element from a list (position numbers start from 0, so addresses[1] is the second element)
```sql
UPDATE Account REMOVE addresses = addresses[1]
```


### Example 5: Put a map entry into a map
```sql
UPDATE Account PUT addresses='Luca', #12:0
```

### Example 6: Remove a value from a map
```sql
UPDATE Account REMOVE addresses='Luca'
```

### Example 7: Update an embedded document

Update command can take a JSON as value to update:

```sql
UPDATE Account SET address={"street":"Melrose Avenue", "city":{"name":"Beverly Hills"}}
```

### Example 8: Update the first 20 records that satisfy a condition
```sql
UPDATE Profile SET nick='Luca' WHERE nick IS NULL LIMIT 20
```

### Example 9: Update a record or insert if it does not already exist
```sql
UPDATE Profile SET nick='Luca' UPSERT WHERE nick='Luca'
```

### Example 10: Update a web counter, avoiding concurrent accesses
```sql
UPDATE Counter INCREMENT viewes = 1 WHERE page='/downloads/' LOCK RECORD
```
### Example 11: Usage of RETURN keyword

```sql
UPDATE ♯7:0 SET gender='male' RETURN AFTER @rid
UPDATE ♯7:0 SET gender='male' RETURN AFTER @version
UPDATE ♯7:0 SET gender='male' RETURN AFTER @this
UPDATE ♯7:0 INCREMENT Counter = 123 RETURN BEFORE $current.Counter
UPDATE ♯7:0 SET gender='male' RETURN AFTER $current.exclude("really_big_field")
UPDATE ♯7:0 ADD out_Edge = ♯12:1 RETURN AFTER $current.outE("Edge")
```

In case a single field is returned, the result is wrapped in a record storing value in "result" field (Just to avoid introducing new serialization – there is no primitive-values collection serialization in binary protocol). Additionally to that, useful fields like version and rid of original record is provided in corresponding fields. New syntax will allow optimizing client-server network traffic.

To know more about the SQL syntax used in Orient, take a look at: [SQL-Query](SQL-Query.md).
