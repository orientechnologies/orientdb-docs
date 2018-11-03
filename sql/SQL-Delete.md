---
search:
   keywords: ['SQL', 'command', 'DELETE', 'delete', 'drop']
---

# SQL - `DELETE`

Removes one or more records from the database.  You can refine the set of records that it removes using the [`WHERE`](SQL-Where.md) clause.

>**NOTE**: Don't use [`DELETE`](SQL-Delete.md) to remove Vertices or Edges. Instead use the [`DELETE VERTEX`](SQL-Delete-Vertex.md) or [`DELETE EDGE`](SQL-Delete-Edge.md) commands, which ensures the integrity of the graph. If you must carry out a `DELETE` you can use the `UNSAFE` keyword to do so. However, if you do, you'll end up with orphaned edge pointers, which you'll have to manually clean up.

**Syntax:**

```sql
DELETE FROM <Class>|CLUSTER:<cluster>|INDEX:<index> [LOCK <default|record>] [RETURN <returning>]
  [WHERE <Condition>*] [LIMIT <MaxRecords>] [TIMEOUT <timeout>]
```
- **`LOCK`** Determines how the database locks the record between load and delete.  It takes one of the following values:
  - `DEFAULT` Defines no locks during the delete.  In the case of concurrent deletes, the MVCC throws an exception.
  - `RECORD` Defines record locks during the delete.
- **`RETURN`** Defines  what values the database returns.  It takes one of the following values:
  - `COUNT` Returns the number of deleted records.  This is the default option.
  - `BEFORE` Returns the number of records before the removal.
- **[`WHERE`](SQL-Where.md)** Filters to the records you want to delete.
- **`LIMIT`** Defines the maximum number of records to delete.
- **`TIMEOUT`** Defines the time period to allow the operation to run, before it times out.
- **`UNSAFE`** Allows for the processing of a DELETE on a Vertex or an Edge, without an exception error. It is not recommended to use this! If you must delete an Edge or a Vertex, use the corresponding commands DELETE EDGE or DELETE VERTEX.   

**Examples:**

- Delete all recods with the surname `unknown`, ignoring case:

  <pre>
  orientdb> <code class="lang-sql userinput">DELETE FROM Profile WHERE surname.toLowerCase() = 'unknown'</code>
  </pre>

For more information, see [SQL Commands](SQL-Commands.md).


