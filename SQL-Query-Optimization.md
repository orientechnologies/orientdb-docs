---
search:
   keywords: ['SQL', 'SELECT', 'query']
---

# SQL Query Optimization

> IMPORTANT: This section refers to OrientDB v 2.2 only. 

> Some of these tips are also valid for previous 2.x versions.

> V 3.0 has a completely new execution planner, so none of these tips can be considered valid on that version.


The SQL executor is a quite complex component and one of the oldest pieces in the architecture of OrientDB, writing
efficient queries requires some knowledge of the internals and of the related components, like indexes and clusters. 
This said, following some basic guidelines allows to reach a good level of performance for most of the typical SQL queries. 
This section is intended to provide these guidelines and to help end users to write efficient SQL queries in OrientDB. 
We will concentrate on SQL `SELECT` statement, but most of these guidelines also apply to other statements.


## Case A: Anatomy of an SQL query

Let's start from a basic but complete use case:

```SQL
SELECT name, surname 
from Person 
WHERE age = 25
ORDER BY name ASC
SKIP 10 LIMIT 10
```

Let's start from the base situation: 
- 1.000.000 Person records in the DB
- evenly distributed by age (0 - 99)
- no indexes defined

For this simple statement, the query executor will perform the following actions:

- fetch records from `Person` class
- for each record, filter by `age`
- calculate projectionis (`name` and `surname`)
- order the resulting records based on `name` property
- skip the first 10 records
- return 10 records

> NOTE: the ordering of the result is executed *after* the calculation of the projections, so the result can only be sorted by
`name` or `surname`, ie. not for `age`

Some facts:

- the SQL executor will scan the whole Person class to fetch all the records that match the condition...
- ...even if only 10.000 of them will match the condition `age = 25`
- the ORDER BY takes into consideration the SKIP/LIMIT, so it keeps in memory only 20 records with the "smallest" name 
(then the SKIP will discard the first 10)
- the sorting is executed in HEAP memory

The most relevant operation here is the scan of 1.000.000 records (likely loading them from disk)

## Case B: Index based filtering

Based on Case A, The first optimization we can do here is adding an index on `age`

```SQL
CREATE INDEX Person.age on Person (age) NOTUNIQUE
```

With this simple optimization, the query execution plan will become as follows:

- fetch records from `Person.age` index, where key = 25
- calculate projectionis (`name` and `surname`)
- order the resulting records based on `name` property
- skip the first 10 records
- return 10 records

Some facts:

- in this case the SQL executor will only fetch from disk the 10.000 records that match `age = 25`
- the ORDER BY still only keeps in memory 20 records with the "smallest" name 
(then the SKIP will discard the first 10)

Compared to Case A, OrientDB only fetches from disk 1/100 of the records, 
so you can expect the original query to be 100 times faster approximately.


