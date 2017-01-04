---
search:
   keywords: ['NET', '.NET', 'C#', 'c sharp', 'ODatabase', 'select']
---

# OrientDB-NET - `Select()`

This method creates an `OSqlSelect` object, which you can use in querying the database.


## Querying the Database

### Syntax

```
// RETRIEVE LIST
List<ODocument> Select(params string[] <projections>)
   .From(<target>)
   .ToList(string <fetchplan>)

// RETRIEVE STRING
string Select(params string[] <projections>)
   .From(<target>)
   .ToString()
```

- **`<projections>`** Defines the columns you want returned.
- **`<target>`** Defines the target you want to operate on.
  - *`string <target>`* Where the target is a class or cluster.
  - *`ORID <target>`* Where the target is a Record ID.
  - *`OSqlSelect <target>`* Where the target is a nested `Select()` operation.
  - *`ODocument <target>`* Where the target is the return value from another database operation.
- **`<fetch-plan>`** Defines the [Fetching Strategy](Fetching-Strategies.md) you want to use.  If you want to issue the query without a fetching strategy, execute the method without passing it arguments.

>Note that you can retrieve either a list of `ODocument` objects or a string value.  

The base `Select()` method operates on an `OSqlSelect` object, which provides additional methods for conditional and grouping operations. For more information on these additional methods, see [Queries](NET-Query.md) 

### Examples

For instance, consider the use case of a database containing contact information for a college mailing list.

- Retrieve the complete contact list:

  ```csharp
  List<ODocument> documents = database.Select()
     .From('Contact')
     .ToList();
  ```

- Retrieve the complete contact list, using a [fetching strategy](Fetching-Strategies.md):

  ```csharp
  List<ODocument> documents = database.Select()
     .From('Contact')
     .ToList('*:-1');
  ```

- Retrieve email of a particular user:

  ```csharp
  string email = database.Select(['email'])
     .From('Contact')
     .Where('userId')
     .Like(893435)
     .ToString();
  ```
