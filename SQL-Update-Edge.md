# SQL - UPDATE EDGE

(Since v. 2.2)

Update one or more edge records in the current database. Remember that OrientDB can work also in schema-less mode, so you can create any field on-the-fly. Furthermore, OrientDB works on collections. This is the reason why OrientDB SQL has some extensions to handle collections.

It is equivalent to [UPDATE](SQL-Update.md) command, but in addition it checks and maintains the graph consistency (vertex pointers) in case you update ```out``` and ```in``` properties.

## Syntax

```sql
UPDATE EDGE <class>|cluster:<cluster>|<recordID>
  [SET|INCREMENT|ADD|REMOVE|PUT <field-name> = <field-value>[,]*]|[CONTENT|MERGE <JSON>]
  [RETURN <returning> [<returning-expression>]]
  [WHERE <conditions>]
  [LOCK default|record]
  [LIMIT <max-records>] [TIMEOUT <timeout>]
```

See [SQL-Update](SQL-Update.md)

## Examples

### Example 1: Change edge endpoint
```sql
UPDATE EDGE Friend set out = (select from Person where name = 'John') where foo = 'bar'
```

