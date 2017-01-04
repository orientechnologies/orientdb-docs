---
search:
   keywords: ['NET', 'C#', 'c sharp', 'query', 'query builder']
---

# OrientDB-NET - Building Queries

When querying a database on OrientDB through your C#/.NET application there are a few options available to you through the [`ODatabase`](NET-Database.md) methods.  While you can issue SQL statements through [`Query()`](NET-Database-Query.md) and [`Command()`](NET-Database-Command.md), there are also methods that allow you to build queries in C#: [`Insert()`](NET-Database-Insert.md), [`Select()`](NET-Database-Select.md), and [`Update()`](NET-Database-Update.md)

These queries support common conditional and grouping methods to organize the data before OrientDB returns it to your application.

- [**Conditional Methods**](NET-Query-Conditions.md) These are in building [`WHERE`](SQL-Where.md) clauses within OrientDB-NET.
- [**Limiter Methods**](NET-Query-Limiter.md) These are used in limited or offsetting the result-set.
- [**Sort Methods**](NET-Query-Sort.md) These are used in sorting or otherwise ordering the result-set.
