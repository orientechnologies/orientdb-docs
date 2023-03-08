---
search:
   keywords: ['java', 'ODatabaseDocument', 'getRecord', 'get record']
---

# ODatabaseDocument - getRecord()

This method retrieves a record from the database.

## Retrieving Records

This method takes an instance of the `OIdentifiable` interface and returns the corresponding record.

### Syntax

```
<RET extends ORecord> RET ODatabaseDocument().getRecord(
   OIdentifiable id)
```

| Argument | Type | Description |
|---|---|---|
| **`id`** | `OIdentifiable` | Defines the record you want |


#### Return Value

This method returns a record instance, which extends the `ORecord` class.  The particular type depends on the record you have stored.  Possible types include,

- `ODocument`
- [`OEdge`](../OEdge.md)
- [`OElement`](../OElement.md)
- `ORecord`
- [`OVertex`](../OVertex.md)

### Example

In cases where you find you are frequently retrieving records by Record ID, you might find in convenient to write a method that streamlines the process, making it easier to call.  For instance,

```java
// INITIALIZE VARIABLES
private ODatabaseDocument db;
...

// FETCH RECORD
public OElement fetchRecord(String rid){

   // Initialize Record ID
   id = ORecordId(rid);

   // Fetch Record
   return db.getRecord(id);
}
```
