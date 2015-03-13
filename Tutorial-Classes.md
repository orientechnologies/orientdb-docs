# Classes

It's easier to introduce OrientDB's basic concepts by outlining the Document Database API. It is more similar to Relational DBMS concepts and therefore a little more natural to follow for many developers. These basic concepts are shared between all of OrientDB's APIs: Document, Object, and Graph.

As with the relational DBMS, OrientDB has the concept of [records](Concepts.md#record) as an element of storage. There are different types of [records](Concepts.md#record), but for the next examples we will always use the [document](Concepts.md#document) type. A [document](Concepts.md#document) is composed of attributes and can belong to one [class](Concepts.md#class). Going forward we will also refer to the attributes with the terms "fields" and "properties".

The concept of [class](Concepts.md#class) is well known to those who program using object-oriented languages. Classes are also used in OrientDB as a type of data model according to certain rules. To learn more about Classes in general take a look at [Wikipedia](http://en.wikipedia.org/wiki/Class_in_object-oriented_programming).

To list all the configured classes, type the [`classes`](Console-Command-Classes.md) command in the console:

    orientdb> classes

    CLASSES:
    ----------------------------------------------+---------------------+-----------+
     NAME                                         | CLUSTERS            | RECORDS   |
    ----------------------------------------------+---------------------+-----------+
     AbstractPerson                               | -1                  |         0 |
     Account                                      | 11                  |      1126 |
     Actor                                        | 91                  |         3 |
     Address                                      | 19                  |       166 |
     Animal                                       | 17                  |         0 |
     ....                                         | ....                |      .... |
     Whiz                                         | 14                  |      1001 |
    ----------------------------------------------+---------------------+-----------+
     TOTAL                                                                    22775 |
    --------------------------------------------------------------------------------+

To create a new class, use the [`create class`](SQL-Create-Class.md) command:

    orientdb> create class Student

    Class created successfully. Total classes in database now: 92

OrientDB allows you to work in a schema-less mode, without defining properties. However, properties are mandatory if you define indexes or constraints. To create a new property use the [`create property`](SQL-Create-Property.md) command. Here is an example of creating three properties against the `Student` class:

    orientdb> create property Student.name string

    Property created successfully with id=1

    orientdb> create property Student.surname string

    Property created successfully with id=2

    orientdb> create property Student.birthDate date

    Property created successfully with id=3

To display the class `Student`, use the [`info class`](Console-Command-Info-Class.md) command:

    orientdb> info class Student

    Class................: Student
    Default cluster......: student (id=96)
    Supported cluster ids: [96]
    Properties:
    -------------------------------+-------------+-------------------------------+-----------+----------+----------+-----------+-----------+
     NAME                          | TYPE        | LINKED TYPE/CLASS             | MANDATORY | READONLY | NOT NULL |    MIN    |    MAX    |
    -------------------------------+-------------+-------------------------------+-----------+----------+----------+-----------+-----------+
     birthDate                     | DATE        | null                          | false     | false    | false    |           |           |
     name                          | STRING      | null                          | false     | false    | false    |           |           |
     surname                       | STRING      | null                          | false     | false    | false    |           |           |
    -------------------------------+-------------+-------------------------------+-----------+----------+----------+-----------+-----------+

To add a constraint, use the [`alter class`](SQL-Alter-Class.md) command. For example, let's specify that the `name` field should be at least 3 characters:

    orientdb> alter property Student.name min 3

    Property updated successfully

To see all the records in a class, use the [`browse class`](Console-Command-Browse-Class.md) command:

    > browse class OUser

In this case we are listing all of the users of the database. This is not particularly secure. You should [further deepen the OrientDB security system](Security.md), but for now `OUser` is a class like any other. For each query the console always shows us the number of the records in the result set and the [record's ID](Concepts.md#RecordID).

    ---+---------+--------------------+--------------------+--------------------+--------------------
      #| RID     |name                |password            |status              |roles
    ---+---------+--------------------+--------------------+--------------------+--------------------
      0|     #5:0|admin               |{SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918|ACTIVE              |[1]
      1|     #5:1|reader              |{SHA-256}3D0941964AA3EBDCB00CCEF58B1BB399F9F898465E9886D5AEC7F31090A0FB30|ACTIVE              |[1]
      2|     #5:2|writer              |{SHA-256}B93006774CBDD4B299389A03AC3D88C3A76B460D538795BC12718011A909FBA5|ACTIVE              |[1]
    ---+---------+--------------------+--------------------+--------------------+--------------------

The first column is a number used as an identifier to display the record's detail. To show the first record in detail, it is necessary to use the [`display record`](Console-Command-Display-Record.md) command with the number of the record, in this case 0:

    orientdb> display record 0
    --------------------------------------------------
    ODocument - Class: OUser   id: #5:0   v.0
    --------------------------------------------------
                    name : admin
                password : {SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918
                  status : ACTIVE
                   roles : [#4:0=#4:0]

