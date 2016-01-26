# SQL - `DELETE VERTEX`

Removes vertices from the database.  This is the equivalent of the [`DELETE`](SQL-Delete.md) command, with the addition of checking and maintaining consistency with edges, removing all cross-references to the deleted vertex in all edges involved.

**Syntax**

```sql
DELETE VERTEX <vertex> [WHERE <conditions>] [LIMIT <MaxRecords>>] [BATCH <batch-size>]
```

- **`<vertex>`** Defines the vertex that you want to remove, using its Class, Record ID, or through a sub-query using the `FROM (<sub-query)` clause.
- **[`WHERE`](SQL-Where.md)** Filter condition to determine which records the command removes.
- **`LIMIT`** Defines the maximum number of records to remove.
- **`BATCH`** Defines how many records the command removes at a time, allowing you to break large transactions into smaller blocks to save on memory usage.  By default, it operates on blocks of 100.


**Example**

- Remove the vertex and disconnect all vertices that point towards it:

  <pre>
  orientdb> <code class="lang-sql userinput">DELETE VERTEX #10:231</code>
  </pre>

- Remove all user accounts marked with an incoming edge on the class `BadBehaviorInForum`:

  <pre>
  orientdb> <code class='lang-sql userinput'>DELETE VERTEX Account WHERE in.@Class CONTAINS 
            'BadBehaviorInForum'</code>
  </pre>

- Remove all vertices from the class `EmailMessages` marked with the property `isSpam`:

  <pre>
  orientdb> <code class="lang-sql userinput">DELETE VERTEX EMailMessage WHERE isSpam = TRUE</code>
  </pre>

- Remove vertices of the class `Attachment`, where the vertex has an edge of the class `HasAttachment` where the property `date` is set before 1990 and the vertex `Email` connected to class `Attachment` with the condition that its property `from` is set to `bob@example.com`:

  <pre>
  orientdb> <code class="lang-sql userinput">DELETE VERTEX Attachment WHERE in[@Class = 'HasAttachment'].date 
            &lt;= "1990" AND in.out[@Class = "Email"].from = 'some...@example.com'</code>
  </pre>


- Remove vertices in blocks of one thousand:

  <pre>
  orientdb> <code class="lang-sql userinput">DELETE VERTEX v BATCH 1000</code>
  </pre>

  This feature was introduced in version 2.1.



## History

### Version 2.1

- Introduces the optional `BATCH` clause for managing batch size on the operation.


### Version 1.4

- Command begins using the Blueprints API.  When working in Java using the OGraphDatabase API, you may experience differences in how the database manages edges.  To force the command to work with the older API, change the Graph DB settings using [`ALTER DATABASE`](SQL-Alter-Database.md#use-graphdb-created-with-releases-before-14).

### Version 1.1

- Initial version.

