<!-- proofread 2015-01-07 SAM -->

# Console - DELETE

Remove one or more records from the database. You can determine which records get deleted using the [`WHERE`](SQL-Where.md) clause.

**Syntax**

```sql
DELETE FROM <target-name> [LOCK <lock-type>] [RETURN <return-type>]
  [WHERE <condition>*] [LIMIT <MaxRecords>] [TIMEOUT <timeout-value>]
```

- **`<target-name>`** Defines the target from which you want to delete records.  Use one of the following target names:
  - `<class-name>` Determines what class you want to delete from.
  - `CLUSTER:<cluster-name>` Determines what cluster you want to delete from.
  - `INDEX:<index-name>` Determines what index you want to delete from.
- **`LOCK <lock-type>`** Defines how the record locks between the load and deletion. It takes one of two types:
  - `DEFAULT` Operation uses no locks. In the event of concurrent deletions, the MVCC throws an exception.
  - `RECORD` Locks the record during the deletion.
- **`RETURN <return-type>`** Defines what the Console returns.  There are two supported return types:
  - `COUNT` Returns the number of deleted records. This is the default return type.
  - `BEFORE` Returns the records before the deletion.
- [**`WHERE <condition>`**](SQL-Where.md) Defines the condition used in selecting records for deletion.
- **`LIMIT`** Defines the maximum number of records to delete.
- **`TIMEOUT`** Defines the time-limit to allow the operation to run before it times out.

>**NOTE**: When dealing with vertices and edges, do not use the standard SQL [`DELETE`](SQL-Delete.md) command.  Doing so can disrupt graph integrity. Instead, use the [`DELETE VERTEX`](SQL-Delete-Vertex.md) or the [`DELETE EDGE`](SQL-Delete-Edge.md) commands.

**Examples**

- Remove all records from the class `Profile`, where the surname is unknown, ignoring case:

  <pre>
  orientdb> <code class="lang-sql userinput">DELETE FROM Profile WHERE surname.toLowerCase() = 'unknown'</code>
  </pre>


>For more information on other commands, see [SQL Commands](SQL.md) and [Console Commands](Console-Commands.md).

