# Classes

Multi-model support in the OrientDB engine provides a number of ways to approaching and understanding its basic concepts.  These concepts are clearest when viewed from the perspective of the Document Database API. Like many database management systems, OrientDB uses the [Record](Concepts.md#record) as an element of storage.  There are many types of records, but with the Document Database API records always use the [Document](Concepts.md#document) type.  Documents are formed by a set of key/value pairs, referred to as fields and properties, and can belong to a class.

The [Class](Concepts.md#class) is a concept drawn from the Object-oriented programming paradigm.  It is a type of data model that allows you to define certain rules for records that belong to it.  In the traditional Document database model, it is comparable to the collection, while in the Relational database model it is the table.

>For more information on classes in general, see [Wikipedia](http://en.wikipedia.org/wiki/Class_in_object-oriented_programming).


## Listing Classes

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




## Creating Classes



To create a new class, use the [`CREATE CLASS`](SQL-Create-Class.md) command:

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Student</code>

Class created successfully. Total classes in database now: 92
</pre>

### Adding Properties to a Class

OrientDB allows you to work in a schema-less mode, without defining properties. However, properties are mandatory if you define indexes or constraints. To create a new property use the [`CREATE PROPERTY`](SQL-Create-Property.md) command. Here is an example of creating three properties against the `Student` class:

<pre>
orientdb> <code class="lang-sql userinput">CREATE PROPERTY Student.name string</code>

Property created successfully with id=1


orientdb> <code class="lang-sql userinput">CREATE PROPERTY Student.surname string</code>

Property created successfully with id=2


orientdb> <code class="lang-sql userinput">CREATE PROPERTY Student.birthDate date</code>

Property created successfully with id=3
</pre>

### Displaying Class Information

To display the class `Student`, use the [`INFO CLASS`](Console-Command-Info-Class.md) command:

<pre>
orientdb> <code class="lang-sql userinput">INFO CLASS Student</code>

Class................: Student
Default cluster......: student (id=96)
Supported cluster ids: [96]
Properties:
-----------+--------+--------------+-----------+----------+----------+----+-----+
 NAME      | TYPE   | LINKED TYPE/ | MANDATORY | READONLY | NOT NULL |MIN |MAX |
           |        | CLASS        |           |          |          |    |     |
-----------+--------+--------------+-----------+----------+----------+----+-----+
 birthDate | DATE   | null         | false     | false    | false    |    |     |
 name      | STRING | null         | false     | false    | false    |    |     |
 surname   | STRING | null         | false     | false    | false    |    |     |
-----------+--------+--------------+-----------+----------+----------+----+-----+
</pre>

### Adding Constraints to Properties

To add a constraint, use the [`ALTER CLASS`](SQL-Alter-Class.md) command. For example, let's specify that the `name` field should be at least 3 characters:

<pre>
orientdb> <code class="lang-sql userinput">ALTER PROPERTY Student.name MIN 3</code>

Property updated successfully
</pre>

## Viewing Records in a Class

To see all the records in a class, use the [`BROWSE CLASS`](Console-Command-Browse-Class.md) command:

<pre>
orientdb> <code class="lang-sql userinput">BROWSE CLASS OUser</code>
</pre>

In this case we are listing all of the users of the database. This is not particularly secure. You should further deepen the OrientDB [Security](Security.md) system, but for now `OUser` is a class like any other. For each query the console always shows us the number of the records in the result set and the [record's ID](Concepts.md#RecordID).

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

The first column is a number used as an identifier to display the record's detail. To show the first record in detail, it is necessary to use the [`DISPLAY RECORD`](Console-Command-Display-Record.md) command with the number of the record, in this case 0:

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
