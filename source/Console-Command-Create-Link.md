# Console - CREATE LINK

The `CREATE LINK` command creates links between two or more records of type Document. This is very useful when you're importing data from a Relational database. In facts in the Relational world relationships are resolved as foreign keys.

Consider this example where the class "Post" has a relationship 1-N to "Comment":

```java
Post 1 ---> * Comment
```

In a Relational database you'll have something like that:

```java
Table Post
+----+----------------+
| Id | Title          |
+----+----------------+
| 10 | NoSQL movement |
| 20 | New OrientDB   |
+----+----------------+

Table Comment
+----+--------+--------------+
| Id | PostId | Text         |
+----+--------+--------------+
|  0 |   10   | First        |
|  1 |   10   | Second       |
| 21 |   10   | Another      |
| 41 |   20   | First again  |
| 82 |   20   | Second Again |
+----+--------+--------------+
```

Using OrientDB, instead, you have a direct relationship as in your object model. So the navigation is from *Post* to *Comment* and not vice versa as for the Relational model. For this reason you need to create a link as **INVERSE**.

## Syntax

```sql
CREATE LINK <link-name> FROM <source-class>.<source-property> TO <destination-class>.<destination-property>
```

Where:
- *link-name* is the name of the property for the link. If not expressed will be overwritten the *destination-property* field
- *source-class*, is the source class
- *source-property*, is the source property
- *destination-class*, is the destination class
- *destination-property*, is the destination property

## Examples

CREATE LINK comments FROM comments.!PostId To posts.Id INVERSE

To know more about other SQL commands look at [SQL commands](Commands.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
