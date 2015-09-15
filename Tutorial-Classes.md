# Classes

It's easier to introduce OrientDB's basic concepts by outlining the Document Database API. It is more similar to Relational DBMS concepts and therefore a little more natural to follow for many developers. These basic concepts are shared between all of OrientDB's APIs: Document, Object, and Graph.

As with the relational DBMS, OrientDB has the concept of [records](Concepts.md#record) as an element of storage. There are different types of [records](Concepts.md#record), but for the next examples we will always use the [document](Concepts.md#document) type. A [document](Concepts.md#document) is composed of attributes and can belong to one [class](Concepts.md#class). Going forward we will also refer to the attributes with the terms "fields" and "properties".

The concept of [class](Concepts.md#class) is well known to those who program using object-oriented languages. Classes are also used in OrientDB as a type of data model according to certain rules. To learn more about Classes in general take a look at [Wikipedia](http://en.wikipedia.org/wiki/Class_in_object-oriented_programming).

To list all the configured classes, type the [`CLASSES`](Console-Command-Classes.md) command in the console:

<pre>
orientdb> <code class="lang-sql userinput">CLASSES</code>

CLASSES:
-------------------+-----------+-----------+
 NAME              | CLUSTERS  | RECORDS   |
-------------------+-----------+-----------+
 AbstractPerson    | -1        |         0 |
 Account           | 11        |      1126 |
 Actor             | 91        |         3 |
 Address           | 19        |       166 |
 Animal            | 17        |         0 |
 ....              | ....      |      .... |
 Whiz              | 14        |      1001 |
-------------------+-----------+-----------+
 TOTAL                               22775 |
-------------------------------------------+
</pre>

To create a new class, use the [`CREATE CLASS`](SQL-Create-Class.md) command:

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Student</code>

Class created successfully. Total classes in database now: 92
</pre>

OrientDB allows you to work in a schema-less mode, without defining properties. However, properties are mandatory if you define indexes or constraints. To create a new property use the [`CREATE PROPERTY`](SQL-Create-Property.md) command. Here is an example of creating three properties against the `Student` class:

<pre>
orientdb> <code class="lang-sql userinput">CREATE PROPERTY Student.name string</code>

Property created successfully with id=1


orientdb> <code class="lang-sql userinput">CREATE PROPERTY Student.surname string</code>

Property created successfully with id=2


orientdb> <code class="lang-sql userinput">CREATE PROPERTY Student.birthDate date</code>

Property created successfully with id=3
</pre>

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

To add a constraint, use the [`ALTER CLASS`](SQL-Alter-Class.md) command. For example, let's specify that the `name` field should be at least 3 characters:

<pre>
orientdb> <code class="lang-sql userinput">ALTER PROPERTY Student.name MIN 3</code>

Property updated successfully
</pre>

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
