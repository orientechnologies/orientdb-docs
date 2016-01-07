<!-- proofread 2015-01-07 SAM -->

# Console - `CREATE LINK`

Creates a link between two or more records of the Document type.

**Syntax**

```sql
CREATE LINK <link-name> FROM <source-class>.<source-property> TO <target-class>.<target-property>
```

- **`<link-name>`** Defines the logical name of the property for the link.  When not expressed, it overwrites the `<target-property>` field.
- **`<source-class>`** Defines the source class for the link.
- **`<source-property>`** Defines the source property for the link.
- **`<target-class>`** Defines the target class for the link.
- **`<target-property>`** Defines the target property for the link.

**Examples**

- Create a 1-*n* link connecting comments to posts:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE LINK comments FROM Comments.!PostId TO Posts.Id INVERSE</code>
  </pre>


## Understanding Links

Links are useful when importing data from a Relational database. In the Relational world, the database resolves relationships as foreign keys. For instance, consider the above example where you need to show instances in the class `Post` as having a 1-*n* relationship to instances in class `Comment`. That is, `Post 1 ---> * Comment`.

In a Relational database, where classes are tables, you might have something like this:

<pre>
reldb> <code class="lang-sql userinput">SELECT * FROM Post;</code>

+----+----------------+
| Id | Title          |
+----+----------------+
| 10 | NoSQL movement |
| 20 | New OrientDB   |
+----+----------------+
2 rows in (0.01 sec)

reldb> <code class="lang-sql userinput">SELECT * FROM Comment;</code>

+----+--------+--------------+
| Id | PostId | Text         |
+----+--------+--------------+
|  0 |   10   | First        |
|  1 |   10   | Second       |
| 21 |   10   | Another      |
| 41 |   20   | First again  |
| 82 |   20   | Second Again |
+----+--------+--------------+
5 rows in sec (0.03 sec)
</pre>

In OrientDB, you have a direct relationship in your object model. Navigation runs from `Post` to `Comment` and not vice versa, (as in the Relational database model). For this reason, you need to create a link as `INVERSE`.


>For more information on SQL commands, see [SQL Commands](Commands.md).  
>For more information on other commands, see [Console Commands](Console-Commands.md).
