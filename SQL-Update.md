# `UPDATE`

Update one or more records in the current database.  Remember: OrientDB can work in schema-less mode, so you can create any field on-the-fly.  Furthermore, the command also supports extensions to work on collections.

**Syntax**:

```sql
UPDATE <class>|cluster:<cluster>|<recordID>
  [SET|INCREMENT|ADD|REMOVE|PUT <field-name> = <field-value>[,]*]|[CONTENT|MERGE <JSON>]
  [UPSERT]
  [RETURN <returning> [<returning-expression>]]
  [WHERE <conditions>]
  [LOCK default|record]
  [LIMIT <max-records>] [TIMEOUT <timeout>]
```

- **`SET`** Defines the fields to update.
- **`INCREMENT`** Increments the field by the value.

  For instance, record at `10` with `INCREMENT value = 3` sets the new value to `13`.  You may find this useful in atomic updates of counters.  Use negative numbers to decrement.  Additionally, you can use `INCREMENT` to implement [sequences and auto-increment](Sequences-and-auto-increment.md).
- **`ADD`** Adds a new item in collection fields.
- **`REMOVE`** Removes an item in collection and map fields.
- **`PUT`** Puts an entry into a map field.
- **`CONTENT`** Replaces the record content with a JSON document.
- **`MERGE`** Merges the record content with a JSON document.
- **`LOCK`** Specifies how to lock the record between the load and update.  You can use one of the following lock strategies:
  - `DEFAULT` No lock.  Use in the event of concurrent updates, the MVCC throws an exception.
  - `RECORD` Locks the record during the update.
- **`UPSERT`** Updates a record if it exists or inserts a new record if it doesn't.  This avoids the need to execute two commands, (one for each condition, inserting and updating).  

  `UPSERT` requires a [`WHERE`](SQL-Where.md) clause and a class target.  There are further limitations on `UPSERT`, explained below.
- **`RETURN`** Specifies an expression to return instead of the record and what to do with the result-set returned by the expression.  The available return operators are:
  - `COUNT` Returns the number of updated records.  This is the default return operator.
  - `BEFORE` Returns the records before the update.
  - `AFTER` Return the records after the update.
- [`WHERE`](SQL-Where.md)
- `LIMIT` Defines the maximum number of records to update.
- `TIMEOUT` Defines the time you want to allow the update run before it times out.

>**NOTE**: The [Record ID](Concepts.md#recordid) must have a `#` prefix.  For instance, `#12:3`.

**Examples**:

- Update to change the value of a field:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Profile SET nick = 'Luca' WHERE nick IS NULL</code>
  
  Updated 2 record(s) in 0.008000 sec(s).
  </pre>

- Update to remove a field from all records:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Profile REMOVE nick</code>
  </pre>

- Update to add a value into a collection:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Account ADD address=#12:0</code>
  </pre>

  >**NOTE**: Beginning with version 2.0.5, the OrientDB server generates a server error if there is no space between `#` and the `=`.  You must write the command as:
  >
  ><pre>
  >orientdb> <code class='lang-sql userinput'>UPDATE Account ADD address = #12:0</code>
  ></pre>

- Update to remove a value from a collection, if you know the exact value that you want to remove:

  Remove an element from a link list or set:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Account REMOVE address = #12:0</code>
  </pre>

  Remove an element from a list or set of strings:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Account REMOVE addresses = 'Foo'</code>
  </pre>

- Update to remove a value, filtering on value attributes.

  Remove addresses based in the city of Rome:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Account REMOVE addresses = addresses[city = 'Rome']</code>
  </pre>

- Update to remove a value, filtering based on position in the collection.

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Account REMOVE addresses = addresses[1]</code>
  </pre>

  This remove the second element from a list, (position numbers start from `0`, so `addresses[1]` is the second elelment).

- Update to put a map entry into the map:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Account PUT addresses = 'Luca', #12:0</code>
  </pre>

- Update to remove a value from a map

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Account REMOVE addresses = 'Luca'</code>
  </pre>

- Update an embedded document.  The [`UPDATE`](SQL-Update.md) command can take JSON as a value to update.

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Account SET address={ "street": "Melrose Avenue", "city": { 
            "name": "Beverly Hills" } }</code>

  </pre>

- Update the first twenty records that satisfy a condition:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Profile SET nick = 'Luca' WHERE nick IS NULL LIMIT 20</code>
  </pre>

- Update a record or insert if it doesn't already exist:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Profile SET nick = 'Luca' UPSERT WHERE nick = 'Luca'</code>
  </pre>

- Update a web counter, avoiding concurrent accesses:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Counter INCREMENT views = 1 WHERE pages = '/downloads/' 
            LOCK RECORD</code>
  </pre>

- Updates using the `RETURN` keyword:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE ♯7:0 SET gender='male' RETURN AFTER @rid</code>
  orientdb> <code class="lang-sql userinput">UPDATE ♯7:0 SET gender='male' RETURN AFTER @version</code>
  orientdb> <code class="lang-sql userinput">UPDATE ♯7:0 SET gender='male' RETURN AFTER @this</code>
  orientdb> <code class="lang-sql userinput">UPDATE ♯7:0 INCREMENT Counter = 123 RETURN BEFORE $current.Counter</code>
  orientdb> <code class="lang-sql userinput">UPDATE ♯7:0 SET gender='male' RETURN AFTER $current.exclude(
            "really_big_field")</code>
  orientdb> <code class="lang-sql userinput">UPDATE ♯7:0 ADD out_Edge = ♯12:1 RETURN AFTER $current.outE("Edge")</code>
  </pre>

In the event that a single field is returned, OrientDB wraps the result-set in a record storing the value in the field `result`.  This avoids introducing a new serialization, as there is no primitive values collection serialization in the binary protocol.  Additionally, it provides useful fields like `version` and `rid` from the original record in corresponding fields.  The new syntax allows for optimization of client-server network traffic.

For more information on SQL syntax, see [`SELECT`](SQL-Query.md).

## Limitations of the `UPSERT` Clause

The `UPSERT` clause only guarantees atomicity when you use a `UNIQUE` index and perform the look-up on the index through the [`WHERE`](SQL-Where.md) condition.

<pre>
orientdb> <code class="lang-sql userinput">UPDATE Client SET id = 23 UPSERT WHERE id = 23</code>
</pre>

Here, you must have a unique index on `Client.id` to guarantee uniqueness on concurrent operations.

