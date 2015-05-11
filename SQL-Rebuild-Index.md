# SQL - REBUILD INDEXES

The **Rebuild Index** command rebuilds an automatic index.

>NOTE: During the rebuilding, any idempotent query against the index skip the index and do a sequential scan. This means queries will be slower until the index is rebuilt. Non-idempotent commands, like INSERT, UPDATE and DELETE, will be blocked waiting for the index rebuild process is finished.

## Syntax

```sql
REBUILD INDEX <index-name>
```

Where:
- **index-name** name of the index. Use * to rebuild all the automatic indices

## See also
- [SQL Create Index](SQL-Create-Index.md)
- [SQL Drop Index](SQL-Drop-Index.md)
- [Indexes](Indexes.md)
- [SQL commands](SQL.md)


## Examples

```sql
REBUILD INDEX Profile.nick
```

```sql
REBUILD INDEX *
```
