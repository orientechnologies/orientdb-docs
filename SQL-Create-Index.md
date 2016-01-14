# SQL - `CREATE INDEX`

Creates a new index.  Indexes can be
- **Unqiue** Where they don't allow duplicates.
- **Not Unique** Where they allow duplicates.
- **Full Text** Where they index any single word of text.

>There are several index algorithms available to determine how OrientDB indexes your database.  For more information on these, see [Indexes](Indexes.md).


**Syntax**

```sql
CREATE INDEX <name> [ON <class> (<property>)] <index-type> [<key-type>]
             METADATA [{<json>}]
```
- **`<name>`** Defines the logical name for the index.  If a schema already exists, you can use `<class>.<property>` to create automatic indexes bound to the schema property.  Because of this, you cannot use the period "`.`" character in index names.
- **`<class>`** Defines the class to create an automatic index for.  The class must already exist.
- **`<property>`** Defines the property you want to automatically index.  The property must already exist.  

  >If the property is one of the Map types, such as `LINKMAP` or `EMBEDDEDMAP`, you can specify the keys or values to use in index generation, using the `BY KEY` or `BY VALUE` clause.

- **`<index-type>`** Defines the index type you want to use.  For a complete list, see [Indexes](Indexes.md).
- **`<key-type>`** Defines the key type.  With automatic indexes, the key type is automatically selected when the database reads the target schema property.  For manual indexes, when not specified, it selects the key at run-time during the first insertion by reading the type of the class.  In creating composite indexes, it uses a comma-separated list of types.
- **`METADATA`** Defines additional metadata through JSON. 

To create an automatic index bound to the schema property, use the `ON` clause, or use a `<class>.<property>` name for the index.  In order to create an index, the schema must already exist in your database.

In the event that the `ON` and `<key-type>` clauses both exist, the database validates the specified property types.  If the property types don't equal those specified in the key type list, it throws an exception.

>You can use list key types when creating manual composite indexes, but bear in mind that such indexes are not yet fully supported.


**Examples**

- Create a manual index to store dates:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE INDEX mostRecentRecords UNIQUE DATE</code>
  </pre>

- Create an automatic index bound to the new property `id` in the class `User`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY User.id BINARY</code>
  orientdb> <code class="lang-sql userinput">CREATE INDEX User.id UNIQUE</code>
  </pre>

- Create a series automatic indexes for the `thumbs` property in the class `Movie`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE INDEX thumbsAuthor ON Movie (thumbs) UNIQUE</code>
  orientdb> <code class="lang-sql userinput">CREATE INDEX thumbsAuthor ON Movie (thumbs BY KEY) UNIQUE</code>
  orientdb> <code class="lang-sql userinput">CREATE INDEX thumbsValue ON Movie (thumbs BY VALUE) UNIQUE</code>
  </pre>

- Create a series of properties and on them create a composite index:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY Book.author STRING</code>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY Book.title STRING</code>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY Book.publicationYears EMBEDDEDLIST INTEGER</code>
  orientdb> <code class="lang-sql userinput">CREATE INDEX books ON Book (author, title, publicationYears) UNIQUE</code>
  </pre>


- Create an index on an edge's date range:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE CLASS File EXTENDS V</code>
  orientdb> <code class="lang-sql userinput">CREATE CLASS Has EXTENDS E</code>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY Has.started DATETIME</code>
  orientdb> <code class="lang-sql userinput">CREATE PROPERTY Has.ended DATETIME</code>
  orientdb> <code class="lang-sql userinput">CREATE INDEX Has.started_ended ON Has (started, ended) NOTUNIQUE</code>
  </pre>

  >You can create indexes on edge classes only if they contain the begin and end date range of validity.  This is use case is very common with historical graphs, such as the example above.

- Using the above index, retrieve all the edges that existed in the year 2014:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM Has WHERE started >= '2014-01-01 00:00:00.000' AND 
            ended < '2015-01-01 00:00:00.000'</code>
  </pre>

- Using the above index, retrieve all edges that existed in 2014 and write them to the parent file:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT outV() FROM Has WHERE started >= '2014-01-01 00:00:00.000' 
            AND ended < '2015-01-01 00:00:00.000'</code>
  </pre>

- Using the above index, retrieve all the 2014 edges and connect them to children files:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT inV() FROM Has WHERE started >= '2014-01-01 00:00:00.000' 
            AND ended < '2015-01-01 00:00:00.000'</code>
  </pre>


- Create an index that includes null values.  

  By default, indexes ignore null values.  Queries against null values that use an index returns no entries.  To index null values, see `{ ignoreNullValues: false }` as metadata.

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE INDEX addresses ON Employee (address) NOTUNIQUE
             METADATA { ignoreNullValues : false }</code>
  </pre>



> For more information, see
>- [`DROP INDEX`](SQL-Drop-Index.md)
>- [Indexes](Indexes.md)
>- [SQL commands](SQL.md)
