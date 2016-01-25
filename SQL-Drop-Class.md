# SQL - DROP CLASS

The **Drop Class** command removes a class from the schema. *NOTE: Pay attention to maintain the schema coherent. For example avoid to remove classes that are super classes of others. The associated cluster won't be deleted.*

## Syntax

```sql
DROP CLASS <class> [ UNSAFE ]
```

Where:
- **class** is the class of the schema
- **UNSAFE** is needed to drop non-empty edge and vertex classes (ATTENTION: it can break data consistency, do it at your own risk)

## See also
- [create class](SQL-Create-Class.md)
- [alter class](SQL-Alter-Class.md)
- [alter cluster](SQL-Alter-Cluster.md)
- [SQL commands](SQL.md)
- [Console commands](Console-Commands.md)

## Examples

Remove the class 'Account':
```sql
DROP CLASS Account
```
