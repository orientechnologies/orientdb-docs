---
search:
   keywords: ['NET', 'C#', 'c sharp', 'query', 'limit', 'skip', 'between']
---

# OrientDB-NET - Limiters

Queries made against large databases can return many more records than you need for a particular operation.  In OrientDB as with other databases, there are limiters available to determine how much data gets returned to you.

## Limiters

There are three limiters available to you, mostly used with [`Select()`](NET-Database-Select.md) queries:

- **`Between()`** This method takes two arguments, which are integers.  It limits the return records to those that occur between them.

- **`Skip()`** This method takes one argument, which is an integer.  It acts as offset, only returning the records that occur after this point.

- **`Limit()`** This mehtod takes one argument, which is an integer.  It defines the maximum number of records to return.

For instance,

```csharp
List<ODocument> blogEntries = database.Select()
   .From('Blog')
   .Limit(50)
   .ToList();
```

Here, you query the database for a list of the first fifty blog entries.
