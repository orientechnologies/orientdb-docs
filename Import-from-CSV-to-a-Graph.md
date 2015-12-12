<!-- proofread 2015-12-11 SAM -->
# Import from a CSV file to a Graph

This example describes the process for importing from a CSV file into OrientDB as a Graph. For the sake of simplicity, consider only these 2 entities:
- POST
- COMMENT

Also consider the relationship between Post and Comment as One-2-Many. One Post can have multiple Comments. We're representing them as they would appear in an RDBMS, but the source could be anything.

With an RDBMS Post and Comment would be stored in 2 separate tables:

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

With an RDBMS, one-2-many references are inverted from the target table (Comment) to the source one (Post). This is due to the inability of an RDBMS to handle a collection of values.

In comparison, using the OrientDB Graph model, relationships are modeled as you would think, when you design an application: POSTs have edges to COMMENTs.

So, with an RDBMS you have:
```
Table POST    <- (foreign key) Table COMMENT
```
With OrientDB, the Graph model uses [Edges](Tutorial-Working-with-graphs.md) to manage relationships:
```
Class POST ->* (collection of edges) Class COMMENT
```
## (1) Export to CSV
If you're using an RDBMS or any other source, export your data in [CSV](Transformer.md#csv) format. The ETL module is also able to extract from [JSON](Extractor.md#json) and an RDBMS directly through [JDBC](Extractor.md#jdbc) drivers. However, for the sake of simplicity, in this example we're going to use [CSV](Transformer.md#csv) as the source format.

Consider having 2 CSV files:
#### File posts.csv
**posts.csv** file, containing all the posts

```
id,title
10,NoSQL movement
20,New OrientDB
```

#### File comments.csv
**comments.csv** file, containing all the comments, with the relationship to the commented post
```
id,postId,text
0,10,First
1,10,Second
21,10,Another
41,20,First again
82,20,Second Again
```

## (2) ETL Configuration
The OrientDB ETL tool requires only a JSON file to define the ETL process as [Extractor](Extractor.md), a list of [Transformers](Transformer.md) to be executed in the pipeline, and a [Loader](Loader.md), to load graph elements into the OrientDB database.

Below are 2 files containing the ETL to import Posts and Comments separately.

### post.json ETL file
```json
{
  "source": { "file": { "path": "/temp/datasets/posts.csv" } },
  "extractor": { "csv": {} },
  "transformers": [
    { "vertex": { "class": "Post" } }
  ],
  "loader": {
    "orientdb": {
       "dbURL": "plocal:/temp/databases/blog",
       "dbType": "graph",
       "classes": [
         {"name": "Post", "extends": "V"},
         {"name": "Comment", "extends": "V"},
         {"name": "HasComments", "extends": "E"}
       ], "indexes": [
         {"class":"Post", "fields":["id:integer"], "type":"UNIQUE" }
       ]
    }
  }
}
```

The Loader contains all the information to connect to an OrientDB database. We have used a plocal database, because it's faster. However, if you have an OrientDB server up & running, use "remote:" instead. Note the classes and indexes declared in the Loader. As soon as the Loader is configured, the classes and indexes are created, if they do not already exist. We have created the index on the Post.id field to assure that there are no duplicates and that the lookup on the created edges (see below) will be fast enough.

### comments.json ETL file
```json
{
  "source": { "file": { "path": "/temp/datasets/comments.csv" } },
  "extractor": { "csv": {} },
  "transformers": [
    { "vertex": { "class": "Comment" } },
    { "edge": { "class": "HasComments",
                "joinFieldName": "postId",
                "lookup": "Post.id",
                "direction": "in"
            }
        }
  ],
  "loader": {
    "orientdb": {
       "dbURL": "plocal:/temp/databases/blog",
       "dbType": "graph",
       "classes": [
         {"name": "Post", "extends": "V"},
         {"name": "Comment", "extends": "V"},
         {"name": "HasComments", "extends": "E"}
       ], "indexes": [
         {"class":"Post", "fields":["id:integer"], "type":"UNIQUE" }
       ]
    }
  }
}
```

This file is similar to the previous one, but the Edge transformer does the job. Since the link found in the CSV goes in the opposite direction (Comment->Post), while we want to model directly (Post->Comment), we used the direction "in" (default is always "out").

## (3) Run the ETL process
Now allow the ETL to run by executing both imports in sequence. Open a shell under the OrientDB home directory, and execute the following steps:

```
$ cd bin
$ ./oetl.sh post.json
$ ./oetl.sh comment.json
```

Once both scripts execute successfully, you'll have your Blog imported into OrientDB as a Graph!

## (4) Check the database
Open the database under the OrientDB console and execute the following commands to check that the import is ok:
```
$ ./console.sh

OrientDB console v.2.0-SNAPSHOT (build 2565) www.orientechnologies.com
Type 'help' to display all the supported commands.
Installing extensions for GREMLIN language v.2.6.0

orientdb> connect plocal:/temp/databases/blog admin admin

Connecting to database [plocal:/temp/databases/blog] with user 'admin'...OK

orientdb {db=blog}> select expand( out() ) from Post where id = 10

----+-----+-------+----+------+-------+--------------
#   |@RID |@CLASS |id  |postId|text   |in_HasComments
----+-----+-------+----+------+-------+--------------
0   |#12:0|Comment|0   |10    |First  |[size=1]
1   |#12:1|Comment|1   |10    |Second |[size=1]
2   |#12:2|Comment|21  |10    |Another|[size=1]
----+-----+-------+----+------+-------+--------------

3 item(s) found. Query executed in 0.002 sec(s).
orientdb {db=blog}> select expand( out() ) from Post where id = 20

----+-----+-------+----+------+------------+--------------
#   |@RID |@CLASS |id  |postId|text        |in_HasComments
----+-----+-------+----+------+------------+--------------
0   |#12:3|Comment|41  |20    |First again |[size=1]
1   |#12:4|Comment|82  |20    |Second Again|[size=1]
----+-----+-------+----+------+------------+--------------

2 item(s) found. Query executed in 0.001 sec(s).
```
