# SQL - DROP INDEX

The **Drop Index** command removes an index on a property defined in the schema.

## Syntax

```sql
DROP INDEX <index-name>|<class>.<property>
```

Where:
- **class** is the class of the schema
- **property**, is the property created into the **class**

## See also
- [SQL Create Index](SQL-Create-Index.md)
- [Indexes](Indexes.md)
- [SQL commands](SQL.md)

## Examples

```sql
DROP INDEX users.Id
```
