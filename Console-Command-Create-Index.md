<!-- proofread 2015-01-07 SAM -->

# Console - `CREATE INDEX`

Create an index on a given property. OrientDB supports three index algorithms and several index types that use these algorithms.

- **SB-Tree Algorithm**
  - `UNIQUE` Does not allow duplicate keys, fails when it encounters duplicates.
  - `NOTUNIQUE` Does allow duplicate keys.
  - `FULLTEXT` Indexes to any single word of text.
  - `DICTIONARY` Does not allow duplicate keys, overwrites when it encounters duplicates.
- **Hash Index Algorithm**
  - `UNIQUE_HASH_INDEX` Does not allow duplicate keys, it fails when it encounters duplicates.
  - `NOTUNIQUE_HASH_INDEX` Does allow duplicate keys.
  - `FULLTEXT_HASH_INDEX` Indexes to any single word.
  - `DICTIONARY` Does not allow duplicate keys, it overwrites when it encounters duplicates.
- **Lucene Engine**
  - `LUCENE` Full text index type using the Lucene Engine.
  - `SPATIAL` Spatial index using the Lucene Engine.

>For more information on indexing, see [Indexes](Indexes.md).


**Syntax**

```sql
CREATE INDEX <index-name> [ON <class-name> (<property-names>)] <index-type> [<key-type>]
```

- **`<index-name>`** Defines a logical name for the index. Optionally, you can use the format `<class-name>.<property-name>`, to create an automatic index bound to the schema property.
  >**NOTE** Because of this feature, index names cannot contain periods.

- **`<class-name>`** Defines the class to index. The class must already exist in the database schema.
- **`<property-names>`** Defines a comma-separated list of properties that you want to index.  These properties must already exist in the database schema.
- **`<index-type>`** Defines the index type that you want to use.
- **`<key-type>`** Defines the key that you want to use. On automatic indexes, this is auto-determined by reading the target schema property where you create the index.  When not specified for manual indexes, OrientDB determines the type at run-time during the first insertion by reading the type of the class.

**Examples**

- Create an index that uses unique values and the SB-Tree index algorithm:

  <pre>
  orientdb> <code class="userinput lang-sql">CREATE INDEX jobs.job_id UNIQUE</code>
  </pre>

>The SQL [`CREATE INDEX`](SQL-Create-Index.md) page provides more information on creating indexes.  More information on indexing can be found under [Indexes](Indexes.md). Further SQL information can be found under [`SQL Commands`](SQL.md).
>
>For more information on other commands, see [Console Commands](Console-Commands.md)
