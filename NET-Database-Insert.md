---
search:
   keywords: ['NET', 'C#', 'ODatabase', 'insert']
---

# OrientDB-NET - `Insert()`

This method initializes an `IOInsert` object, which you can use to insert data onto the database.

## Inserting Data

When you issue this command without any additional methods, it initializes an `IOInsert` object, which you can then further operate on in building the insertion.

### Syntax

```
IOInsert Insert()
   .Into(<class>)
   .Set(<field>, <value>)

IOInsert Insert()
   .Cluster(<cluster>)
   .Set(<field>, <value>)
```

- **`<class>`** Defines the class to use.
- **`<cluster>`** Defines the cluster to use.
- **`<field>`** Defines the field to set.
- **`<value>`** Defines the value to set on the field.

The above methods allow you to build the `IOInsert` object.  You can then execute a processing command to run the query against the database.  There are two such methods available to you,

- **`Run()`** Executes the insertion on the database and returns an `ODocument` object.
- **`ToString()`** Executes the insertion on the database and returns a string of the added record.

### Example
