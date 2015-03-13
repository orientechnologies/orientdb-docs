# SQL - REBUILD INDEXES

The **Rebuild Index** command rebuilds an automatic index.

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
