---
search:
   keywords: ['SQL', 'UPDATE EDGE', 'update', 'edge']
---

# SQL - `UPDATE EDGE`

Updates edge records in the current database.  This is the equivalent of the [`UPDATE`](SQL-Update.md) command, with the addition of checking and maintaining graph consistency with vertices, in the event that you update the `out` and `in` properties.

Bear in mind that OrientDB can also work in schema-less mode, allowing you to create fields on the fly.  Furthermore, that it works on collections and necessarily includes some extensions to the standard SQL for handling collections.

This command was introduced in version 2.2.

**Syntax**

```sql
UPDATE EDGE <edge> 
  [SET|INCREMENT|ADD|REMOVE|PUT <field-name> = <field-value>[,]*]|[CONTENT|MERGE <JSON>]
  [RETURN <returning> [<returning-expression>]]
  [WHERE <conditions>]
  [LOCK default|record]
  [LIMIT <max-records>] [TIMEOUT <timeout>]
```

- **`<edge>`** Defines the edge that you want to update.  You can choose between:
  - *Class* Updating edges by class.
  - *Cluster* Updating edges by cluster, using `CLUSTER` prefix.
  - *Record ID* Updating edges by Record ID.
- **`SET`** Updates the field to the given value.
- **`INCREMENT`** Increments the given field by the value.
- **`ADD`** Defines an item to add to a collection of fields.
- **`REMOVE`** Defines an item to remove from a collection of fields.
- **`PUT`** Defines an entry to put into a map field.
- **`RETURN`** Defines the expression you want to return after running the update.
  - `COUNT` Returns the number of updated records.  This is the default operator.
  - `BEFORE` Returns the records before the update.
  - `AFTER` Returns the records after the update.
- **[`WHERE`](SQL-Where.md)** Defines the filter conditions.
- **`LOCK`** Defines how the record locks between the load and update.  You can choose between the following lock strategies:
  - `DEFAULT` Disables locking.  Use this in the event of concurrent updates.  It throws an exception in the event of conflict.
  - `RECORD` Locks the record during the update.
- **`LIMIT`** Defines the maximum number of records to update.


**Examples**

- Change the edge endpoint:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE EDGE Friend SET out = (SELECT FROM Person WHERE name = 'John') 
            WHERE foo = 'bar'</code>
  </pre>


>For more information, see
>
>- [`UPDATE`](SQL-Update.md)
>- [SQL Commands](SQL.md)
