# Console - CREATE INDEX

The SQL `CREATE INDEX` command creates an index on a property defined in the schema.

Indexes can be:
- **UNIQUE**, doesn't allow duplicated
- **NOT UNIQUE**, allows duplicates
- **FULL-TEXT**, by indexing any single word of the text. It's used in query with the operator [CONTAINSTEXT](SQL-Where.md#operators)

## Syntax

```xml
CREATE INDEX <name> [ON <class-name> (prop-names)] <type> [<key-type>]
```
Where:

- **name** logical name of index. Can be **<code>&lt;class&gt;.&lt;property&gt;</code>** to create an automatic index bound to a schema property. In this case **class** is the class of the schema and **property**, is the property created into the class. Notice that in another case index name can't contain '.' symbol
- **class-name** name of class that automatic index created for. Class with such name must already exist in database
- **prop-names** comma-separated list of properties that this automatic index is created for. Property with such name must already exist in schema
- **type**, between `UNIQUE`, `NOTUNIQUE` and `FULLTEXT`
- **key-type**, is the type of key (Optional). On automatic indexes is auto-determined by reading the target schema property where the index is created. If not specified for manual indexes, at run-time during the first insertion the type will be auto determined by reading the type of the class.

## Examples

```java
CREATE INDEX users.Id UNIQUE
```

For more information look at [CREATE INDEX command](SQL-Create-Index.md).

For complete index guide look at [Index guide](Indexes.md).

To know more about other SQL commands look at [SQL commands](SQL.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
