---
search:
   keywords: ['NET', 'C#', 'ODatabase', 'query']
---

# OrientDB-NET - `Query()`

This method issues SQL queries against the OrientDB database.  It returns a list of `ODocument` objects from the result-set.

## Querying the Database

In some cases you may find features in OrientDB that are not yet available through OrientDB-NET.  You can utilize these features by passing SQL statements for them through the `Query()` method.  It returns a list of `ODocument` objects that you can operate on further.

It is comparable to the [`Command()`](NET-Database-Command.md) method.

### Syntax

```
// QUERY DATABASE
List<ODocument> ODatabase.Query(string SQL)

// QUERY DATABASE WITH FETCH PLAN
List<ODocument> ODatabase.Query(string SQL,
   string fetch-plan)
```

- **`SQL`** Defines the SQL statement to use.
- **`fetch-plan`** Defines the [Fetching Strategy](Fetching-Strategies.md) to use.

### Example

In situations where you execute the same or very similar queries with some frequency or in cases where you need to run a query that has no comparable function available in OrientDB-NET, you can issue the SQL statement manually through this menthod.

```csharp
using Orient.Client;
using System;
...

// FETCH MATCHING DOCUMENTS FROM CLASS
public List<ODocument> FetchRecords(ODatabase database,
    string className, Dictionary<string, string> conditions)
{
  // LOG OPERATION
  Console.WriteLine("Querying Class: {0}", className);

  // BUILD QUERY
  List<string> baseQuery = [
    String.Format('SELECT FROM {0}', className)];

  // CHECK FOR CONDITIONAL VALUES
  if(conditions.Count > 0)
  {
    // ADD WHERE
    baseQuery.Add('WHERE');

    // ADD CONDITIONS
    foreach(KeyValuePair<string, string> condition in conditions)
    {
      string entry = String.Format("{0}={1}",
        condition.Key, condition.Value);

      baseQuery.Add(entry);
    }

    // JOIN QUERY
    string query = String.Join(' ', baseQuery);

    // RUN QUERY
    return database.Query(query);
  }
}
```

In the event that you would like to execute the query with a fetching strategy, you can do so through the second argument.

```csharp
using Orient.Client;
using System;

// FETCH ALL RECORDS WITH FETCHING STRATEGY
public List<ODocument> FetchAll(ODatabase database,
    string className, string fetchPlan)
{
  // LOG OPERATION
  Console.WriteLine("Fetching All Records from {0}",
    className);

  // BUILD QUERY
  string query = String.Format("SELECT FROM {0}", className);

  // RUN QUERY
  return database.Query(query, fetchPlan);
}
```
