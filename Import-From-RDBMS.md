<!-- proofread 2015-12-11 SAM -->
# Import from RDBMS

*NOTE: As of OrientDB 2.0, you can use the [OrientDB-ETL module](https://github.com/orientechnologies/orientdb-etl/wiki/Import-from-DBMS) to import data from an RDBMS. You can use ETL also with 1.7.x by installing it as a separate module.*

OrientDB supports a subset of SQL, so importing a database created as "Relational" is straightforward. For the sake of simplicity, consider your Relational database having just these two tables:
- POST
- COMMENT

Where the relationship is between Post and comment as One-2-Many.

```
TABLE POST:
+----+----------------+
| id | title          |
+----+----------------+
| 10 | NoSQL movement |
| 20 | New OrientDB   |
+----+----------------+

TABLE COMMENT:
+----+--------+--------------+
| id | postId | text         |
+----+--------+--------------+
|  0 |   10   | First        |
|  1 |   10   | Second       |
| 21 |   10   | Another      |
| 41 |   20   | First again  |
| 82 |   20   | Second Again |
+----+--------+--------------+
```

- [Import using the Document Model (relationships as links)](Import-RDBMS-to-Document-Model.md)
- [Import using the Graph Model (relationships as edges)](Import-RDBMS-to-Graph-Model.md)
