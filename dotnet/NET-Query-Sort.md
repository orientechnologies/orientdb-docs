---
search:
   keywords: ['NET', 'C#', 'c sharp', 'query', 'sort']
---

# OrientDB-NET - Sort

When OrientDB returns a result-set to your application, it isn't always arranged in a manner that is convenient to your uses.  Rather than putting your own resources to sorting results, you can add sort methods to the query to ensure that OrientDB returns the records in the order you want.


## Sorting Records

There are three methods available to you in sorting the result-sets OrientDB sends you on [`Select()`](NET-Database-Select.md) queries.

- **`OrderBy()`** This method takes a `params string[]` argument that defines the fields to use in sorting the result-set.

- **`Ascending()`** This method sorts the result-set in ascending order.

- **`Descending()`** This method sorts the result-set in descending order.

For instance,

```csharp
List<ODocument> blogs = database.Select()
   .From("Blog")
   .OrderBy('date')
   .Descending()
   .Limit(10)
   .ToList();
```

Here, you have a web application that is rendering a series of blog entries.  You would like the entries sorted by the date and display the ten most recent entries on the home page.
