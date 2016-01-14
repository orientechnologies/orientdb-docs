# SQL - `CREATE LINK`

Creates a link between two simple values.

**Syntax**

```sql
CREATE LINK <link> TYPE [<link-type>] FROM <source-class>.<source-property> TO <destination-class>.<destination-property> [INVERSE]
```

- **`<link`>** Defines the property for the link.  When not expressed, the link overwrites the `<destination-property>` field.
- **`<link-type>`** Defines the type for the link.  In the event of an inverse relationship, (the most common), you can specify `LINKSET` or `LINKLIST` for 1-*n* relationships.
- **`<source-class>`** Defines the class to link from.
- **`<source-property>`** Defines the property to link from.
- **`<destination-class>`** Defines the class to link to.
- **`<destination-property>`** Defines the property to link to.
- **`INVERSE`** Defines whether to create a connection on the opposite direction.  This option is common when creating 1-*n* relationships from a Relational database, where they are mapped at the opposite direction.

**Example**

- Create an inverse link between the classes `Comments` and `Post`:
  
   <pre>
   orientdb> <code class="lang-sql userinput">CREATE LINK comments TYPE LINKSET FROM Comments.PostId TO Posts.Id 
             INVERSE</code>
   </pre>


>For more information, see
>
>- [Relationships](Concepts.md#relationships)
>- [Importing from Relational Databases](Import-RDBMS-to-Document-Model.md)
>- [SQL Commands](SQL.md)

## Conversion from Relational Databases

You may find this useful when imported data from a Relational database.  In the Relational world, the database uses links to resolve foreign keys.  In general, this is not the way to create links, but rather a way to convert two values in two different classes into a link.  

As an example, consider a Relational database where the table `Post` has a 1-*n* relationship with the table `Comment`.  That is `Post 1 ---> * Comment`, such as:

<pre>
reldb> <code class="lang-sql userinput">SELECT * FROM Post;</code>

+----+----------------+
| Id | Title          |
+----+----------------+
| 10 | NoSQL movement |
+----+----------------+
| 20 | New OrientDB   |
+----+----------------+

reldb> <code class="lang-sql userinput">SELECT * FROM Comment;</code>

+----+--------+--------------+
| Id | PostID | Text         |
+----+--------+--------------+
|  0 | 10     | First        |
+----+--------+--------------+
|  1 | 10     | Second       |
+----+--------+--------------+
| 21 | 10     | Another      |
+----+--------+--------------+
| 41 | 20     | First again  |
+----+--------+--------------+
| 82 | 20     | Second Again |
+----+--------+--------------+
</pre>

In OrientDB, instead of a separate table for the relationship, you use a direct relationship as your object model.  Meaning that the database navigates from `Post` to `Comment` and not vice versa, as with Relational databases.  To do so, you would also need to create the link with the `INVERSE` option.  
