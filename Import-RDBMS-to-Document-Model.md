# Import from RDBMS to Document Model

This guide is to import an exported relational database into OrientDB using the Document Model. If you're using the Graph Model, look at [Import into Graph Model](Import-RDBMS-to-Graph-Model.md).

OrientDB supports a subset of SQL, so importing a database created as "Relational" is straightforward. You can import a database using the API, the [OrientDB Studio visual tool](Home-page.md) or the [Console](Console-Commands.md). In this guide the console is used.

For the sake of simplicity consider your Relational database having just these two tables:
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

Since the Relational Model hasn't Object Oriented concepts you can create a class per table in OrientDB. Furthermore in the RDBMS references One-2-Many are inverted from the target table to the source one. In OrientDB the Object Oriented model is respected and you've a collection of links from POST to COMMENT instances.
In a RDBMS you have:
```
Table POST    <- (foreign key) Table COMMENT
```
In OrientDB the Document model uses [Links](Concepts.md#Relationships) to manage relationships:
```
Class POST ->* (collection of links) Class COMMENT
```

# Export your Relational Database

Most of Relational DBMSs provide a way to export a database in SQL format. What you need is a text file containing the SQL INSERT commands to recreate the database from scratch. Take a look to the documentation of your RDBMS provider. Below the link to the export utilities for the most common RDBMSs:
- MySQL: http://www.abbeyworkshop.com/howto/lamp/MySQL_Export_Backup/index.html
- Oracle: http://www.orafaq.com/wiki/Import_Export_FAQ
- MS SqlServer: http://msdn.microsoft.com/en-us/library/ms140052.aspx

At this point you should have a <code>.sql</code> file containing the Relational database exported in SQL format like this:
```sql
DROP TABLE IF EXISTS post;
CREATE TABLE post (
id INT(11) NOT NULL AUTO_INCREMENT,
title VARCHAR(128),
PRIMARY KEY (id)
);

DROP TABLE IF EXISTS comment;
CREATE TABLE comment (
id INT(11) NOT NULL AUTO_INCREMENT,
postId INT(11),
text TEXT,
PRIMARY KEY (id),
CONSTRAINT `fk_comments`
    FOREIGN KEY (`postId` )
    REFERENCES `post` (`id` )
);

INSERT INTO POST (id, title) VALUES( 10, 'NoSQL movement' );
INSERT INTO POST (id, title) VALUES( 20, 'New OrientDB' );

INSERT INTO COMMENT (id, postId, text) VALUES( 0, 10, 'First' );
INSERT INTO COMMENT (id, postId, text) VALUES( 1, 10, 'Second' );
INSERT INTO COMMENT (id, postId, text) VALUES( 21, 10, 'Another' );
INSERT INTO COMMENT (id, postId, text) VALUES( 41, 20, 'First again' );
INSERT INTO COMMENT (id, postId, text) VALUES( 82, 20, 'Second Again' );
```

# Modify the SQL script

What we're going to do is to change the generated SQL file to be imported into a OrientDB database. Don't execute the following commands but include them into the SQL file to be executed in batch mode by the [OrientDB Console](Console-Commands.md).

## What database to use?

Before to import the database you need an open connection to a OrientDB database. You can create a brand new database or use an existent one. You can use a volatile in-memory only database or a persistent disk-based one.

For persistent databases you can choose to create it in a remote server or locally using the "plocal" mode avoiding the server at all. This is suggested to have better performance on massive insertion.

### Create a new database

#### Use the embedded mode

```sql
CREATE DATABASE plocal:/tmp/db/blog admin admin plocal document
```

Thes [CREATE DATABASE](Console-Command-Create-Database.md) command creates a new database under the directory "/tmp/db/blog".

#### Use the remote mode

Or start a OrientDB server and create a database using the "remote" protocol in the connection URL. Example:
```sql
CREATE DATABASE remote:localhost/blog root dkdf383dhdsj plocal document
```

*NOTE: When you create a remote database you need the server's credentials to do it. Use the user "root" and the password stored in <code>config/orientdb-server-config.xml</code> file.*

### Use an existent database

#### Use the embedded mode

If you already have a database where to import, just open it:
```sql
CONNECT plocal:/tmp/db/blog admin admin
```
#### Use the remote mode

```sql
CONNECT remote:localhost/blog admin admin
```
## Declare the 'massive insert' intent

In order to obtain the maximum of performance you can tell to OrientDB what you're going to do. These are called "Intents". The "Massive Insert" intent will auto tune the OrientDB engine for fast insertion.

Add the following line:
```sql
DECLARE INTENT massiveinsert
```
## Create the classes, one for tables

Since the Relational Model hasn't Object Oriented concepts you can create a class per table. Change the <code>CREATE TABLE ...</code> statements with <code>CREATE CLASS</code>:
```sql
CREATE CLASS POST
CREATE CLASS COMMENT
```

### Pseudo Object Oriented database

This is the case when your Relational database was created using a OR-Mapping tool like [Hibernate](http://www.hibernate.org) or [Data Nucleus](http://www.datanucleus.org) (JDO).

In this case you have to re-build the original Object Oriented structure directly in OrientDB using the Object Oriented capabilities of OrientDB.

## Remove not supported statements

Leave only the <code>INSERT INTO</code> statements. OrientDB supports not only INSERT statement but for this purpose is out of scope.

## Create links

At this point you need to create links as relationships in OrientDB. The  [CREATE LINK command](SQL-Create-Link.md) creates links between two or more records of type Document. In facts in the Relational world relationships are resolved as foreign keys.

Using OrientDB, instead, you have direct relationship as in your object model. So the navigation is from *Post* to *Comment* and not viceversa as for Relational model. For this reason you need to create a link as **INVERSE**.

Execute:
```sql
CREATE LINK comments TYPE linkset FROM comment.postId TO post.id INVERSE
```

## Remove old constraints

This is an optional step. Now you've direct links the field 'postId' has no more sense, so remove it:
```sql
UPDATE comment REMOVE postId
```

## Expected output

After these steps the expected output should be similar to that below:
```sql
CONNECT plocal:/tmp/db/blog admin admin

DECLARE INTENT massiveinsert

CREATE CLASS POST
CREATE CLASS COMMENT

INSERT INTO POST (id, title) VALUES( 10, 'NoSQL movement' );
INSERT INTO POST (id, title) VALUES( 20, 'New OrientDB' );

INSERT INTO COMMENT (id, postId, text) VALUES( 0, 10, 'First' );
INSERT INTO COMMENT (id, postId, text) VALUES( 1, 10, 'Second' );
INSERT INTO COMMENT (id, postId, text) VALUES( 21, 10, 'Another' );
INSERT INTO COMMENT (id, postId, text) VALUES( 41, 20, 'First again' );
INSERT INTO COMMENT (id, postId, text) VALUES( 82, 20, 'Second Again' );

CREATE LINK comments TYPE linkset FROM comment.postId To post.id INVERSE
UPDATE comment REMOVE postId
```

# Import the records

Now you have modified the SQL script execute it by invoking the console tool in batch mode (text file just created as first argument). Example of importing the file called "database.sql":
```
$ console.sh database.sql
```

# Enjoy

That's all. Now you've a OrientDB database where relationships are direct without JOINS.

Now enjoy with your new document-graph database and the following queries:

Select all the post with comments:
```sql
orientdb> SELECT * FROM post WHERE comments.size() > 0
```

Select all the posts where comments contain the word 'flame' in the text property (before as column):
```sql
orientdb> SELECT * FROM post WHERE comments CONTAINS ( text like '%flame%' )
```

Select all the posts commented today. In this case we're assuming a property "date" is present in Comment class:
```sql
orientdb> SELECT * FROM post WHERE comments CONTAINS ( date > '2011-04-14 00:00:00' )
```


To know more about other SQL commands look at [SQL commands](SQL.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
