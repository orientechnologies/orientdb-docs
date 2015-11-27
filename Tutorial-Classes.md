<!-- proofread 2015-11-26 SAM -->
# Classes


Multi-model support in the OrientDB engine provides a number of ways in approaching and understanding its basic concepts.  These concepts are clearest when viewed from the perspective of the Document Database API. Like many database management systems, OrientDB uses the [Record](Concepts.md#record) as an element of storage.  There are many types of records, but with the Document Database API, records always use the [Document](Concepts.md#document) type.  Documents are formed by a set of key/value pairs, referred to as fields and properties, and can belong to a class.

The [Class](Concepts.md#class) is a concept drawn from the Object-oriented programming paradigm. It is a type of data model that allows you to define certain rules for records that belong to it. In the traditional Document database model, it is comparable to the collection, while in the Relational database model it is comparable to the table.

>For more information on classes in general, see [Wikipedia](http://en.wikipedia.org/wiki/Class_in_object-oriented_programming).

To list all the configured classes on your system, use the [`CLASSES`](Console-Command-Classes.md) command in the console:

<pre>
orientdb> <code class="lang-sql userinput">CLASSES</code>

CLASSES:
-------------------+------------+----------+-----------+
 NAME              | SUPERCLASS |CLUSTERS  | RECORDS   |
-------------------+------------+----------+-----------+
 AbstractPerson    |            | -1       |         0 |
 Account           |            | 11       |      1126 |
 Actor             |            | 91       |         3 |
 Address           |            | 19       |       166 |
 Animal            |            | 17       |         0 |
 ....              | ....       | ....     |      .... |
 Whiz              |            | 14       |      1001 |
-------------------+------------+----------+-----------+
 TOTAL                                           22775 |
-------------------------------------------------------+
</pre>



## Working with Classes

In order to start using classes with your own applications, you need to understand how to create and configure them for use.  As a concept, the class in OrientDB has the closest relationship with the table in relational databases, but (unlike tables) classes can be schema-less, schema-full or mixed. Classes can inherit from other classes, creating trees of classes.  Each class has its own cluster or clusters, (created by default, if none are defined).

>For more information on classes in OrientDB, see [Class](Concepts.md#class).

To create a new class, use the [`CREATE CLASS`](SQL-Create-Class.md) command:

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Student</code>

Class created successfully. Total classes in database now: 92
</pre>

This creates a class called `Student`.  Given that no cluster was defined in the [`CREATE CLASS`](SQL-Create-Class.md) command, OrientDB creates a default cluster called `student`, to contain records assigned to this class. For the moment, the class has no records or properties tied to it.  It is now displayed in the [`CLASSES`](Console-Command-Classes.md) listings.



### Adding Properties to a Class

As mentioned above, OrientDB does allow you to work in a schema-less mode.  That is, it allows you to create classes without defining their properties. However, in the event that you would like to define indexes or constraints for your class, properties are mandatory. Following the comparison to relational databases, if classes in OrientDB are similar to tables, properties are the columns on those tables.

To create new properties on `Student`, use the [`CREATE PROPERTY`](SQL-Create-Property.md) command in the console:

<pre>
orientdb> <code class="lang-sql userinput">CREATE PROPERTY Student.name STRING</code>

Property created successfully with id=1


orientdb> <code class="lang-sql userinput">CREATE PROPERTY Student.surname STRING</code>

Property created successfully with id=2


orientdb> <code class="lang-sql userinput">CREATE PROPERTY Student.birthDate DATE</code>

Property created successfully with id=3
</pre>

These commands create three new properties on the `Student` class to provide you with areas to define the individual student's name, surname and date of birth.



### Displaying Class Information

On occasion, you may need to reference a particular class to see what clusters it belongs to and any properties configured for its use.  Using the [`INFO CLASS`](Console-Command-Info-Class.md) command, you can display information on the current  configuration and properties of a class.

To display information on the class `Student`, use the [`INFO CLASS`](Console-Command-Info-Class.md) command:

<pre>
orientdb> <code class="lang-sql userinput">INFO CLASS Student</code>

Class................: Student
Default cluster......: student (id=96)
Supported cluster ids: [96]
Properties:
-----------+--------+--------------+-----------+----------+----------+-----+-----+
 NAME      | TYPE   | LINKED TYPE/ | MANDATORY | READONLY | NOT NULL | MIN | MAX |
           |        | CLASS        |           |          |          |     |     |
-----------+--------+--------------+-----------+----------+----------+-----+-----+
 birthDate | DATE   | null         | false     | false    | false    |     |     |
 name      | STRING | null         | false     | false    | false    |     |     |
 surname   | STRING | null         | false     | false    | false    |     |     |
-----------+--------+--------------+-----------+----------+----------+-----+-----+
</pre>

### Adding Constraints to Properties

Constraints create limits on the data values assigned to properties.  For instance, the type, the minimum or maximum size of, whether or not a value is mandatory or if null values are permitted to the property.

To add a constraint, use the [`ALTER PROPERTY`](SQL-Alter-Property.md) command:



<pre>
orientdb> <code class="lang-sql userinput">ALTER PROPERTY Student.name MIN 3</code>

Property updated successfully
</pre>

This command adds a constraint to `Student` on the `name` property.  It sets it so that any value given to this class and property must have a minimum of three characters.


## Viewing Records in a Class

Classes contain and define records in OrientDB.  You can view all records that belong to a class using the [`BROWSE CLASS`](Console-Command-Browse-Class.md) command and data belonging to a particular record with the [`DISPLAY RECORD`](Console-Command-Display-Record.md) command.

In the above examples, you created a `Student` class and defined the schema for records that belong to that class, but you did not create these records or add any data.  As a result, running these commands on the `Student` class returns no results.  Instead, for the examples below, consider the `OUser` class.

<pre>
orientdb> <code class="lang-sql userinput">INFO CLASS OUser</code>

CLASS 'OUser'

Super classes........: [OIdentity]
Default cluster......: ouser (id=5)
Supported cluster ids: [5]
Cluster selection....: round-robin
Oversize.............: 0.0

PROPERTIES
----------+---------+--------------+-----------+----------+----------+-----+-----+
 NAME     | TYPE    | LINKED TYPE/ | MANDATORY | READONLY | NOT NULL | MIN | MAX |
          |         | CLASS        |           |          |          |     |     |
----------+---------+--------------+-----------+----------+----------+-----+-----+
 password | STRING  | null         | true      | false    | true     |     |     |
 roles    | LINKSET | ORole        | false     | false    | false    |     |     |
 name     | STRING  | null         | true      | false    | true     |     |     |
 status   | STRING  | null         | true      | false    | true     |     |     |
----------+---------+--------------+-----------+----------+----------+-----+-----+

INDEXES (1 altogether)
-------------------------------+----------------+
 NAME                          | PROPERTIES     |
-------------------------------+----------------+
 OUser.name                    | name           |
-------------------------------+----------------+

</pre>

OrientDB ships with a number of default classes, which it uses in configuration and in managing data on your system, (the classes with the `O` prefix shown in the [`CLASSES`](Console-Command-Classes.md) command output).  The `OUser` class defines the users on your database.

To see records assigned to the `OUser` class, run the [`BROWSE CLASS`](Console-Command-Browse-Class.md) command:


<pre>
orientdb> <code class="lang-sql userinput">BROWSE CLASS OUser</code>

---+------+-------+--------+-----------------------------------+--------+-------+
 # | @RID | @Class| name   | password                          | status | roles |
---+------+-------+--------+-----------------------------------+--------+-------+
 0 | #5:0 | OUser | admin  | {SHA-256}8C6976E5B5410415BDE90... | ACTIVE | [1]   |
 1 | #5:1 | OUser | reader | {SHA-256}3D0941964AA3EBDCB00EF... | ACTIVE | [1]   |
 2 | #5:2 | OUser | writer | {SHA-256}B93006774CBDD4B299389... | ACTIVE | [1]   |
---+------+-------+--------+-----------------------------------+--------+-------+
</pre>

|||
|---|-----|
|![](images/warning.png)| In the example, you are listing all of the users of the database.  While this is fine for your initial setup and as an example, it is not particularly secure. To further improve security in production environments, see [Security](Security.md).|

When you run [`BROWSE CLASS`](Console-Command-Browse-Class.md), the first column in the output provides the identifier number, which you can use to display detailed information on that particular record.

To show the first record browsed from the `OUser` class, run the [`DISPLAY RECORD`](Console-Command-Display-Record.md) command:

<pre>
orientdb> <code class="lang-sql userinput">DISPLAY RECORD 0</code>

------------------------------------------------------------------------------+
 Document - @class: OUser                      @rid: #5:0      @version: 1    |
----------+-------------------------------------------------------------------+
     Name | Value                                                             |
----------+-------------------------------------------------------------------+
     name | admin                                                             |
 password | {SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873F8A81F6F2AB... |
   status | ACTIVE                                                            |
    roles | [#4:0=#4:0]                                                       |
----------+-------------------------------------------------------------------+
</pre>

Bear in mind that this command references the last call of [`BROWSE CLASS`](Console-Command-Browse-Class.md).  You can continue to display other records, but you cannot display records from another class until you browse that particular class.

