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
  [UPSERT]
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
- **`REMOVE`** Defines an item to remove from a collection of fields.
- **`RETURN`** Defines the expression you want to return after running the update.
  - `COUNT` Returns the number of updated records.  This is the default operator.
  - `BEFORE` Returns the records before the update.
  - `AFTER` Returns the records after the update.
- **[`WHERE`](SQL-Where.md)** Defines the filter conditions.
- **`LOCK`** Defines how the record locks between the load and update.  You can choose between the following lock strategies:
  - `DEFAULT` Disables locking.  Use this in the event of concurrent updates.  It throws an exception in the event of conflict.
  - `RECORD` Locks the record during the update.
- **`UPSERT`** Updates a record if it exists or inserts a new record if it doesn't.  This avoids the need to execute two commands, (one for each condition, inserting and updating). 
- **`LIMIT`** Defines the maximum number of records to update.


**Examples**

- Change the edge endpoint:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE EDGE Friend SET out = (SELECT FROM Person WHERE name = 'John') 
            WHERE foo = 'bar'</code>
  </pre>
 
 ## Limitations of the `UPSERT` Clause

The `UPSERT` clause only guarantees atomicity when you use a `UNIQUE` index and perform the look-up on the index through the [`WHERE`](SQL-Where.md) condition.

<pre>
orientdb> <code class="lang-sql userinput">UPDATE EDGE hasAssignee SET foo = 'bar' UPSERT WHERE id = 56</code>
</pre>

Here, you must have a unique index on `id` to guarantee uniqueness on concurrent operations.



>For more information, see
>
>- [`UPDATE`](SQL-Update.md)
>- [SQL Commands](SQL-Commands.md)
