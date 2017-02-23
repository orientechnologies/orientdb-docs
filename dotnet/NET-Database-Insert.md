---
search:
   keywords: ['NET', 'C#', 'ODatabase', 'insert']
---

# OrientDB-NET - `Insert()`

This method inserts records into the database.


## Inserting Data

Using this method you can insert records into the database.  By itself, it initializes an `IOInsert` object, which you can that operate on to further define the data you want to insert.


### Syntax

```
IOInsert ODatabase.Insert()
   .Into(class)
   .Set(field, value)

IOInsert ODatabase.Insert()
   .Cluster(cluster)
   .Set(field, value)
```

- **`class`** Defines the class to use.
- **`cluster`** Defines the cluster to use.
- **`field`** Defines the field to set.
- **`value`** Defines the value to set on the field.

The above methods allow you to build the `IOInsert` object.  You can then execute a processing command to run the query against the database.  There are two such methods available to you,

- **`Run()`** Executes the insertion on the database and returns an `ODocument` object.
- **`ToString()`** Executes the insertion on the database and returns a string of the added record.

### Example

For instance, say that you are developing an accounting application in C# and want to support migration.  You receive a CSV file from a spreadsheet application and want to insert its records into OrientDB.

```csharp
using Orient.Client;
using (TextFieldParser parser = new TexFieldParser("$HOME/2016-report.csv"))
{
   // INITIALIZE DATABASE
   ODatabase database = ODatabase("localhost", 2424, "account-app",
      ODatabaseType.PLocal, "user", "passwd");

   // INITIALIZE PARSER
   parser.TextFieldType = FieldType.Delmited;
   parser.SetDelmiters(",");

   // MIGRATE DATA
   while (!parser.EndOfData)
   {
      // INSERT ROW
      string[] fields = parser.ReadFields();
			ODocument test = database.Insert()
				 .Into("Account")
				 .Set("name", field[0])
         .Set("contact", field[1])
         .Set("status", field[2])
         .Run();
   }
}
```
