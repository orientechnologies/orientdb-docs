<!-- proofread 2015-11-26 SAM -->
# Record ID


In OrientDB, each record has its own self-assigned unique ID within the database called [Record ID](Concepts.md#wiki-RecordID) or RID. It is composed of two parts:

```
#<cluster-id>:<cluster-position>
```

That is,

- `<cluster-id>` The cluster identifier.
- `<cluster-position>` The position of the data within the cluster.

Each database can have a maximum of 32,767 clusters, or 2<sup>15</sup> - 1.  Each cluster can handle up to 9,223,372,036,780,000 records, or 2<sup>63, namely 8,223,372 trillion records.

> The maximum size of a database is 2<sup>78</sup> records, or 302,231,454,903 trillion records.  Due to limitations in hardware resources, OrientDB has not been tested at such high numbers, but there are users working with OrientDB in the billions of records range.

## Loading Records

Each record has a [Record ID](Concepts.md#RecordID), which notes the physical position of the record inside the database. What this means is that when you load a record by its RID, the load is significantly faster than it would be otherwise.

In document and relational databases, the more data that you have, the slower the database responds. OrientDB handles relationships as physical links to the records. The relationship is assigned only once, when the edge is created `O(1)`. You can compare this to relational databases, which compute the relationship every time the database is run `O(log N)`.  In OrientDB, the size of a database does not effect the traverse speed. The speed remains constant, whether for one record or one hundred billion records. This is a critical feature in the age of Big Data.

To directly load a record, use the [`LOAD RECORD`](Console-Command-Load-Record.md) command in the console.


<pre>
orientdb> <code class="lang-sql userinput">LOAD RECORD #12:4</code>

--------------------------------------------------------
 ODocument - @class: Company  @rid: #12:4  @version: 8 
-------------+------------------------------------------
        Name | Value
-------------+------------------------------------------
   addresses | [NOT LOADED: #19:159]
      salary | 0.0
   employees | 100004
          id | 4
        name | Microsoft4
 initialized | false
     salary2 | 0.0
  checkpoint | true
     created | Sat Dec 29 23:13:49 CET 2012
-------------+------------------------------------------
</pre>

The [`LOAD RECORD`](Console-Command-Load-Record.md) command returns some useful information about this record. It shows:

- that it is a [document](Concepts.md#document). OrientDB supports different types of records, but document is the only type covered in this chapter.

- that it belongs to the `Company` class.

- that its current version is `8`. OrientDB uses an [MVCC system](Transactions.md#Optimistic-Transaction).  Every time you update a record, its version increments by one.

- that we have different field types: floats in `salary` and `salary2`, integers for `employees` and `id`, string for `name`, booleans for `initialized` and `checkpoint`, and date-time for `created`.

- that the field `addresses` has been `NOT LOADED`. It is also a `LINK` to another record, `#19:159`.  This is a relationship. For more information on this concept, see [Relationships](Tutorial-Relationships.md).  

