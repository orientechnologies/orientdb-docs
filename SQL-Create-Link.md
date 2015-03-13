# SQL - CREATE LINK

The **Create Link** transform two simple values in a link. This is very useful when you're importing data from a Relational database. In facts in the Relational world relationships are resolved as foreign keys.

This is not the way to create links in general, but a way to convert two values in two different classes in a link. To create a link in OrientDB look at [Relationships](Concepts.md#Relationships). For more information about importing a Relational Database into OrientDB look at [Import from RDBMS to Document Model](Import-RDBMS-to-Document-Model.md).

Consider this example where the class "Post" has a relationship 1-N to "Comment":

```java
Post 1 ---> * Comment
```

In a Relational database you'll have something like that:

```
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

Using OrientDB, instead, you have direct relationship as in your object model. So the navigation is from *Post* to *Comment* and not viceversa as for Relational model. For this reason you need to create a link as **INVERSE**.

## Syntax

`CREATE LINK <link-name> TYPE [<link-type>] FROM <source-class>.<source-property> TO <destination-class>.<destination-property> [INVERSE]`

Where:
- **link-name** is the name of the property for the link. If not expressed will be overwritten the *destination-property* field
- **link-type**, optional, is the type to use for the link. In case of inverse relationships (the most commons) you can specify LINKSET or LINKLIST for 1-N relationships
- **source-class**, is the source class
- **source-property**, is the source property
- **destination-class**, is the destination class
- **destination-property**, is the destination property
- **INVERSE**, tells to create the connection on the opposite direction. This is common when you've imported 1-N relationships from a RDBMS where they are mapped at the opposite direction

## Examples

```sql
CREATE LINK comments TYPE LINKSET FROM comments.PostId TO posts.Id INVERSE
```

To know more about other SQL commands look at [SQL](SQL.md).
