---
search:
   keywords: ['NET', 'C#', 'c sharp', 'query', 'where']
---

# OrientDB-NET - Conditionals

In SQL, the [`WHERE`](SQL-Where.md) clause defines conditions for returning data.  When building queries in OrientDB-NET on [`ODatabase`](NET-Database.md) objects, there are a series of methods available in setting conditions on the query result-set.

There are two parts to a conditional statement, the field you want to set the condition on and the value you want from that field.

## Setting the Field

In setting the field for a condition, there are three methods available to you.

- **`Where()`** Defines the initial field in the condition.

- **`And()`** Defines a condition where the previous cases and this both return true.

- **`Or()`** Defines a condition where either the previous cases or this return true.

For instance, say you want to retrieve blog entries from a database where the user is considered active and the entries are flagged as published.

```csharp
List<ODocument> blogEntries = database.Select()
   .From('Blog')
   .Where('user-status').Equals('active')
   .And('published').Equals(true)
   .ToList();
```

## Setting the Value

Once you have defined the field for a condition, the second method is the value you want to check on that field.  There are several methods available to use in checking the values.

- **`Equals()`** Returns the record if the value of the field is equal to the given argument.
- **`NotEquals()`** Returns the record if the value of the field is not equal to the given argument.
- **`Lesser()`** Returns the record if the value of the field is less than the given argument.
- **`LesserEqual()`** Returns the record if the value of the field is less than or equal to the given argument.
- **`Greater()`** Returns the record if the value of the field is greater than the given argument.
- **`GreaterEqual()`** Returns the record if the value of the field is greater than or equal to the given argument.
- **`Like()`** Returns the record if the value of the field is similar to the given argument.
- **`In()`** Returns the record if the value occurs in the given argument list.
- **`Lucene()`** Returns true if the value occurs in the given argument, searched using the Lucene Engine.
- **`IsNull()`** Returns the record if the value of the field is `NULL`.
- **`Contains()`** Returns the record if the value of the field contains the given argument.

For instance, say you want to retrieve blog entries for active users that have not set their profile picture.

```csharp
List<string, ODocument> blogEntries = database.Select()
   .From('Blog')
   .Where('user-status').Equals('active')
   .And('profile-picture').IsNull()
   .ToList();
```
