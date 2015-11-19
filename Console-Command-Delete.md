# Console - DELETE

The **Delete** command deletes one or more records from the database. The set of records involved are taken by the [WHERE](SQL-Where.md) clause.

>NOTE: Don't use SQL DELETE to remove Vertices or Edges but use the DELETE VERTEX and DELETE EDGE commands that assure the integrity of the graph.

## Syntax

```sql
DELETE FROM <Class>|cluster:<cluster>|index:<index> [LOCK <default|record>] [RETURN <returning>]
  [WHERE <Condition>*] [LIMIT <MaxRecords>] [TIMEOUT <timeout>]
```

Where:
- **LOCK** specifies how the record is locked between the load and the delete. It can be a value between:
 - *DEFAULT*, no lock. In case of concurrent delete, the MVCC throws an exception
 - *RECORD*, locks the record during the delete
- **RETURN** specifies what to return. It can be a value between:
 - **COUNT**, the default, returns the number of deleted records
 - **BEFORE**, returns the records before the delete
- WHERE, [SQL-Where](SQL-Where.md) condition to select records to update
- LIMIT, sets the maximum number of records to update
- TIMEOUT, if any limits the update operation to a timeout

## Examples

Delete all the records with surname equals to 'unknown' ignoring the case:

```sql
DELETE FROM Profile WHERE surname.toLowerCase() = 'unknown'
```

To know more about other SQL commands look at [SQL commands](SQL.md).
