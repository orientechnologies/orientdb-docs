# Import from a Relational Database

Relational databases typically query and manipulate data with SQL.  Given that OrientDB supports a subset of SQL, it is relatively straightfoward to import data from a Relational databases to OrientDB.
You can manage imports using the Java API, [OrientDB Studio](Home-page.md) or the [OrientDB Console](Console-Commands.md).  The examples below use the Console.

>This guide covers importing into the Document Model.  Beginning with version 2.0, you can import into the Graph Model using the [ETL Module](Import-from-DBMS.md).  From version 1.7.x you can still use ETL by installing it as a separate module

For these examples, assume that your Relational database, (referred to as `reldb` in the code), contains two tables: `Post` and `Comment`.  The relationship between these tables is one-to-many.

<pre>
reldb> <code class='lang-sql userinput'>SELECT * FROM post;</code>

+----+----------------+
| id | title          |
+----+----------------+
| 10 | NoSQL movement |
| 20 | New OrientDB   |
+----+----------------+


reldb> <code class='lang-sql userinput'>SELECT * FROM comment;</code>

+----+--------+--------------+
| id | postId | text         |
+----+--------+--------------+
|  0 |   10   | First        |
|  1 |   10   | Second       |
| 21 |   10   | Another      |
| 41 |   20   | First again  |
| 82 |   20   | Second Again |
+----+--------+--------------+
</pre>


Given that the Relational Model doesn't use concepts from Object Oriented Programming, there are some things to consider in the transition from a Relational database to OrientDB.

- In Relational databases there is no concept of class, so in the import to OrientDB you need to create on class per table.

- In Relational databases, one-to-many references invert from the target table to the source table.

  ```
  Table POST    <- (foreign key) Table COMMENT
  ```

  In OrientDB, it follows the Object Oriented Model, so you have a collection of [links](Concepts.md#Relationships) connecting instances of `Post` and `Comment`. 

  ```
  Class POST ->* (collection of links) Class COMMENT
  ```

## Exporting Relational Databases

Most Relational database management systems provide a way to export the database into SQL format.  What you specifically need from this is a text file that contains the SQL [`INSERT`](SQL-Insert.md) commands to recreate the database from scratch.  For example,

- MySQL: the [`mysqldump`](https://dev.mysql.com/doc/refman/5.6/en/mysqldump.html) utility.
- Oracle Database: the [Datapump](http://www.orafaq.com/wiki/Data_Pump) utilities.
- Microsoft SQL Server: the [Import and Export Wizard](https://msdn.microsoft.com/en-us/library/ms141209.aspx).

When you run this utility on the example database, it produces an `.sql` file that contains the exported SQL of the Relational database.

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


## Modifying the Export File

Importing from the Relational database requires that you modify the SQL file to make it usable by OrientDB.  In order to do this, you need to open the SQL file, (called `export.sql` below), in a text editor and modify the commands there.  Once this is done, you can execute the file on the Console using batch mode.

### Database

In order to import a data into OrientDB, you need to have a database ready to receive the import.  Note that the example `export.sql` file doesn't include statements to create the database.  You can either create a new database or use an existing one.

#### Using New Databases

In creating a database for the import, you can either create a volatile in-memory database, (one that is only available while OrientDB is running), or you can create a persistent disk-based database.  For a persistent database, you can create it on a remote server or locally through the PLocal mode.

The recommended method is PLocal, given that it offers better performance on massive inserts.

- Using the embedded Plocal mode:

  <pre>
  $ <code class="lang-sh userinput">vim export.sql</code>
  <code class="lang-sql userinput">
  CREATE DATABASE PLOCAL:/tmp/db/blog admin_user admin_passwd PLOCAL DOCUMENT
  </code></pre>
  
  Here, the [`CREATE DATABASE`](Console-Command-Create-Database.md) command creates a new database at `/tmp/db/blog`.

- Using the Remote mode:

  <pre>
  $ <code class="lang-sh userinput">vim export.sql</code>
  <code class="lang-sql userinput">
  CREATE DATABASE REMOTE:localhost/blog root_user dkdf383dhdsj PLOCAL DOCUMENT
  </code></pre>
  
  This creates a database at the URL `http://localhost/blog`.

>**NOTE**: When you create remote databases, you need the server credentials to access it.  The user `root` and its password are stored in the `$ORIENTDB_HOME/config/orientdb-server-config.xml` configuration file.


#### Using Existing Databases

In the event that you already have a database set up and ready for the import, instead of creating a database add a line that connects to that databases, using the [`CONNECT`](Console-Command-Connect.md) command.

- Using the embedded PLocal mode:

  <pre>
  $ <code class="lang-sh userinput">vim export.sh</code>
  <code class="lang-sql userinput">
  CONNECT PLOCAL:/tmp/db/blog admin_user admin_passwd
  </code></pre>

  This connects to the database at `/tmp/db/blog`.

- Using the Remote mode:

  <pre>
  $ <code class="lang-sh userinput">vim export.sql</code>
  <code class="lang-sql userinput">
  CONNECT REMOTE:localhost/blog admin_user admin_passwd
  </code></pre>
  
  This connects to the database at the URL `http://localhost/blog`.
  
  
### Declaring Intent
  
In the SQL file, after you create or connect to the database, you need to declare your intention to perform a massive insert.  Intents allow you to utilize automatic tuning OrientDB for maximum performance on particular operations, such as large inserts or reads.

<pre>
$ <code class="lang-sh userinput">vim export.sh</code>
...<code class="lang-sql userinput">
DECLARE INTENT MASSIVEINSERT
</code></pre>


### Creating Classes 

Relational databases have no parallel to concepts in Object Oriented programming, such as classes.  Conversely, OrientDB doesn't have a concept of tables in the Relational sense. 

Modify the SQL file, changing `CREATE TABLE` statements to [`CREATE CLASS`](SQL-Create-Class.md) commands:

<pre>
$ <code class="lang-sql userinput">vim export.sql</code>
...<code class="lang-sql userinput">
CREATE CLASS Post
CREATE CLASS Comment
</code></pre>

>**NOTE**: In cases where your Relational database was created using Object Relational Mapping, or ORM, tools, such as  [Hibernate](http://www.hibernate.org) or [Data Nucleus](http://www.datanucleus.org), you have to rebuild the original Object Oriented Structure directly in OrientDB.

### Create Links

In the Relational database, the relationship between the `post` and `comment` was handled through foreign keys on the `id` fields.  OrientDB handles relationships differently, using links between two or more records of the Document type.

By default, the [`CREATE LINK`](SQL-Create-Link.md) command creates a direct relationship in your object model. Navigation goes from `Post` to `Comment` and not vice versa, which is the case for the Relational database.  You'll need to use the `INVERSE` keyword to make the links work in both directions.

Add the following line after the [`INSERT`](SQL-Insert.md) statements.

<pre>
$ <code class="lang-sh userinput">vim export.sql</code>
...<code class="lang-sql userinput">
CREATE LINK comments TYPE LINKSET FROM comment.postId TO post.id INVERSE
</code></pre>

### Remove Constraints

Unlike how Relational databases handle tables, OrientDB does not require you to create a strict schema on your classes.  The properties on each class are defined through the [`INSERT`](SQL-Insert.md) statements.  That is, `id` and `title` on `Post` and `id`, `postId` and `text` on `Comment`.

Given that you created a link in the above section, the property `postId` is no longer necessary.  Instead of modifying each [`INSERT`](SQL-Insert.md) statement, you can use the [`UPDATE`](SQL-Update.md) command to remove them at the end:

<pre>
$ <code class="lang-sh userinput">vim export.sql</code>
...<code class="lang-sql userinput">
UPDATE comment REMOVE postId
</code></pre>

Bear in mind, this is an optional step.  The database will still function if you leave this field in place.

### Expected Output

When you've finished, remove any statements that OrientDB does not support.  With the changes above this leaves you with a file similar to the one below:

<pre>
$ <code class="lang-sh userinput">cat export.sql</code>

CONNECT plocal:/tmp/db/blog admin admin

DECLARE INTENT MASSIVEINSERT

CREATE CLASS Post
CREATE CLASS Comment

INSERT INTO Post (id, title) VALUES( 10, 'NoSQL movement' )
INSERT INTO Post (id, title) VALUES( 20, 'New OrientDB' )

INSERT INTO Comment (id, postId, text) VALUES( 0, 10, 'First' )
INSERT INTO Comment (id, postId, text) VALUES( 1, 10, 'Second' )
INSERT INTO Comment (id, postId, text) VALUES( 21, 10, 'Another' )
INSERT INTO Comment (id, postId, text) VALUES( 41, 20, 'First again' )
INSERT INTO Comment (id, postId, text) VALUES( 82, 20, 'Second Again' )

CREATE LINK comments TYPE LINKSET FROM Comment.postId TO Post.id INVERSE
UPDATE Comment REMOVE postId
</pre>


## Importing Databases

When you finish modifying the SQL file, you can execute it through the Console in batch mode.  This is done by starting the Console with the SQL file given as the first argument.

<pre>
$ <code class="lang-sql userinput">$ORIENTDB_HOME/bin/console.sh export.sql</code>
</pre>

When the OrientDB starts, it executes each of the commands given in the SQL files, creating or connecting to the database, creating the classes and inserting the data from the Relational database.  You now have a working instance of OrientDB to use.

### Using the Database

You now have an OrientDB Document database where relationships are direct and handled without the use of joins.

- Query for all posts with comments:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM Post WHERE comments.size() > 0</code>
  </pre>

- Query for all posts where the comments contain the word "flame" in the `text` property:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM Post WHERE comments CONTAINS(text 
            LIKE '%flame%')</code>
  </pre>

- Query for all posts with comments made today, assuming that you have added a `date` property to the `Comment` class:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM Post WHERE comments CONTAINS(date > 
            '2011-04-14 00:00:00')</code>
  </pre>


>For more information, see
>
>- [SQL commands](SQL.md)
>- [Console-Commands](Console-Commands.md)
