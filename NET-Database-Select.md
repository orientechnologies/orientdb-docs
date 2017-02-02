---
search:
   keywords: ['NET', '.NET', 'C#', 'c sharp', 'ODatabase', 'select']
---

# OrientDB-NET - `Select()`

This method creates an `OSqlSelect` object, which you can use in querying the database.


## Querying the Database

Eventually, you'll want to access the data that you're storing on OrientDB.  This method allows you to construct a query to use in retrieving documents from the database.

### Syntax

```
// RETRIEVE LIST
List<ODocument> ODatabase.Select(params string[] projections)
   .From(target)
   .ToList(string fetchplan)

// RETRIEVE STRING
string ODatabase.Select(params string[] projections)
   .From(target)
   .ToString()
```

- **`projections`** Defines the columns you want returned.
- **`target`** Defines the target you want to operate on.
  - *`string target`* Where the target is a class or cluster.
  - *`ORID target`* Where the target is a Record ID.
  - *`OSqlSelect target`* Where the target is a nested `Select()` operation.
  - *`ODocument target`* Where the target is the return value from another database operation.
- **`fetch-plan`** Defines the [Fetching Strategy](Fetching-Strategies.md) you want to use.  If you want to issue the query without a fetching strategy, execute the method without passing it arguments.

>Note that you can retrieve either a list of `ODocument` objects or a string value.  

The base `Select()` method operates on an `OSqlSelect` object, which provides additional methods for conditional and grouping operations. For more information on these additional methods, see [Queries](NET-Query.md)

### Examples

This method supports two return values: strings and lists.  In cases where you find you use on form more often than others, you might build a helper function to save yourself time and typing.

```csharp
using Orient.Client;
using System;

// FETCH ALL DOCUMENTS BY CLASS
public List<ODocument> ClassFetch(ODatabase database, string className)
{
  // LOG OPERATION
  Console.WriteLine("Fetching Documents from: {0}", className);

  // FETCH DOCUMENTS
  return database.Select().From(className).ToList();
}
```

For classes that contain particularly large number of records, you might find it more useful to issue the query with a fetching strategy.

```csharp
public List<ODocument> ClassFetch(ODatabase database,
    string className, string fetchPlan)
{
  // LOG OPERATION
  Console.WriteLine("Fetching Documents from: {0}", className);

  return database.Select().From(className).ToList(fetchPlan);
}
```

>For more information on queries in OrientDB-NET, see [Queries](NET-Query.md).
