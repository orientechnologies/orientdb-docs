---
search:
   keywords: ['SQL', 'SELECT', 'query']
---

# SQL Query Optimization

> **IMPORTANT**: This section refers to OrientDB v 2.2 only. 

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
`name` or `surname`, ie. not by `age`

Some facts:

- the SQL executor will scan the whole Person class to fetch all the records that match the condition...
- ...even if only 10.000 of them will match the condition `age = 25`
- the ORDER BY takes into consideration the SKIP/LIMIT, so it keeps in memory only 20 records with the "smallest" name 
(then the SKIP will discard the first 10)
- the sorting is executed in HEAP memory

The most relevant operation here is the scan of 1.000.000 records (likely loading them from disk)

## Case B: Index based filtering

Based on Case A, the first optimization we can do here is adding an index on `age`

```SQL
CREATE INDEX Person.age on Person (age) NOTUNIQUE
```

With this simple optimization, the query execution plan becomes as follows:

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

## Case C: Index based sorting

Based on Case A (suppose no other indexes are available, ie. we never performed the optimization provided with Case B), another optimization we can do is adding an index on `name` property to speed up the sorting operation.

```SQL
CREATE INDEX Person.name on Person (name) NOTUNIQUE
```

With this optimization, the query execution plan becomes as follows:

- fetch records from `Person.name` index in ascending order
- calculate projectionis (`name` and `surname`)
- for each record, filter by `age`
- collect the first 20 valid results
- discard 10 records (SKIP)
- return 10 records

Some facts:

- There is no need for sorting here, as the index already provides records sorted by `name`
- If you are lucky enough, the first 20 records will have `age = 20`, so the query will take ~1/50.000 of the original one...
- ...but if you are particularly unlucky, to find 20 records that match `age = 20` you will have to scan all the original dataset, so the performance will be the same as the Case A

> **IMPORTANT:** Sorting based on indexes can be **only** performed on tree-based indexes (ie. UNIQUE and NOTUNIQUE indexes). All the other types of indexes (eg. NOTUNIQUE_HASH_INDEX, UNIQUE_HASH_INDEX, LUCENE) *do not* support sorting, so they will be ignored for ORDER BY operations.


## Case D: Index based filtering + sorting

Let's try to mix Case B and C together and see if we can do better:

The naive approach of using both indexes together won't work:

```SQL
//WRONG!

CREATE INDEX Person.age on Person (age) NOTUNIQUE
CREATE INDEX Person.name on Person (name) NOTUNIQUE
```

With these index definitions, OrientDB will be able to use only one index to optimize the query. In this case it will choose the index for filtering and will discard the other one.

> **IMPORTANT**: THE EXECUTION PLAN **CANNOT** MIX INDEXES FOR SORTING AND FILTERING. IT WILL ALWAYS CHOOSE THE INDEX FOR FILTERING AND WILL IGNORE THE OTHER ONE.

OrientDB can actually exploit indexes for both filtering and sorting, but it has to be the *same* index:

```SQL
//CORRECT

CREATE INDEX Person.age_name on Person (age, name) NOTUNIQUE
```

With this index, the query execution plan becomes much more efficient:

- fetch records from `Person.age_name` index in ascending order, `where age = 25`
- discard 10 records (SKIP)
- return 10 records

This execution will ALWAYS fetch only 20 records from the storage, so the query performance is always 50.000x faster than Case A


## Case E: Equality and Inequality conditions

Let's consider three different statements:

```SQL
SELECT FROM Person WHERE age = 25

SELECT FROM Person WHERE age <> 25

SELECT FROM Person WHERE age > 25
```

The first statement has an equality expression; to execute it, OrientDB can use **any type** of index (apart from fulltext and spatial), ie. tree based and hash indexes.

The second statement has a "not equals" condition. OrientDB will *never* use indexes to optimize it. `<>` is equivalent to `!=`

The third statement has a "range" condition (range operators include `>`, `<`, `>=`, `<=`); OrientDB can only use three-based indexes (ie. UNIQUE and NOTUNIQUE) to optimize range queries. Hash indexes will be ignored.


## Case F: Composite indexes - full match

A composite index is an index defined on multiple properties. Consider the following

```SQL
CREATE CLASS Person
CREATE PROPERTY Person.name STRING
CREATE PROPERTY Person.surname STRING
CREATE PROPERTY Person.age INTEGER
CREATE PROPERTY Person.karma INTEGER
```

And an index defined as follows:

```SQL
CREATE INDEX Person.name_surname_age_karma on Person (name, surname, age, karma) NOTUNIQUE
```

This index can of course be used for a full match, eg.

```SQL
SELECT FROM Person WHERE name = 'foo' AND surname = 'bar' AND age = 25 AND karma = 100
```

## Case F - Composite indexes - partial match

Consider the schema and the index defined in Case E. This index can also be used for partial queries, eg.
the following queries can use that index to optimize the search

```SQL
SELECT FROM Person WHERE name = 'foo' AND surname = 'bar' AND age = 25 

SELECT FROM Person WHERE name = 'foo' AND surname = 'bar'

SELECT FROM Person WHERE name = 'foo' 
```

The partial match is allowed only on a prefix of the index definition. 
The following query **won't** be optimized by the above mentioned index:

```SQL
//NOT INDEXED
SELECT FROM Person WHERE surname = 'bar' AND age = 25 AND karma = 100

//NOT INDEXED
SELECT FROM Person WHERE age = 25 

//NOT INDEXED
SELECT FROM Person WHERE karma = 100
```

> IMPORTANT: Only **tree-based** indexes (ie UNIQUE, NOTUNIQUE) can be used for partial match. Hash indexes (eg. UNIQUE_HASH_INDEX, NOTUNIQUE_HASH_INDEX) will be **ignored** for partial match.


## Case G - Composite indexes - range queries

Tree-based indexes can be used to optimize both equality and range queries. The same applies to composite indexes, with the only limitation that the range condition has to be on the last property that is used for index search. Let's make it clear with an example:

Given the schema and the index defined in Case E, consider the following query:

```SQL
SELECT FROM Person WHERE name = 'foo' AND surname = 'bar' AND age = 25 AND karma > 100
```

This query will be executed using the full index (ie. on properties `name`, `surname`, `age` and `karma`).

Now consider the following:

```SQL
SELECT FROM Person WHERE name = 'foo' AND surname = 'bar' AND age > 25 AND karma > 100
```

now the range condition is on `age`, that is the third property in the index definition. In this case, the query will be executed as follows:

- fetch from the index, based on `name`, `surname` and `age`
- filter the resulting records by `karma`

So if you have 1000 records with the same name, surname and age, but only one has karma > 100, the query will fetch all the 1000 records and filter them one by one, based on `karma` value.

This happens because now the first range condition is `age > 25`, this condition *short-circuits the range query*

The same would have happened if the condition on `karma` was an equality condition (ie. `karma = 100`); all the conditioins after the first range condition are ignored in partial index match.

> **IMPORTANT:** range conditions short-circuit partial index usage


## Case H - Composite indexes - partial match and sorting

As discussed in Case D, indexes can be used for filtering and sorting at the same time. This also applies to partial match.
Consider the domain and the index defined in Case E and the following query:

```
SELECT FROM Person WHERE name = 'foo' AND surname = 'bar' ORDER BY age
```

In this case the query executor will use the index for both filtering (partial match on `name` and `surname`) and for sorting.

The conditions for this to happen are following:

- the filtering has to be done based on equality conditions (ie. no range conditions)
- the sorting has to be executed on a property that, in the index definition, is right next to the properties used for filtering

To make it clear, consider this scheme:

```SQL
CREATE INDEX theIndex on TheClass (prop1, prop2... propN) NOTUNIQUE
```
```SQL
SELECT FROM TheClass
WHERE
prop1 = ...
AND prop2 = ...
...
AND propX = ...
ORDER BY `propX+1`
```

```
          ALL EQUALITY CONDITIONS            NOTHING IN 
                    |                        THE MIDDLE
 +------------------+--------------------+     |
 |                                       |     |
equality    equality    equality    equality   |        
condition   condition   condition   condition  |  ORDER BY
    |           |           |           |      |    |       
    V           V           V           V      |    V       
  prop1       prop2       ...         propX    V  propX+1     ....   propN
  
```

> **IMPORTANT:** both partial match and sorting are allowed only on tree-based indexes


## Case H - IN condition

Consider a query like this:

```SQL
SELECT FROM Person WHERE name in ['foo', 'bar']
```

This query can be optimized with an index that is defined on `name` property only (eg. not on an index that is defined on `name` and `surname`).

> this is not a limitation in the index engine, but just a limitation in the implementation of the SQL executor, there is a chance that in next 2.2.x releases it will be addressed. This limitation does not exist in V 3.0.

The same applies to a query on a composite index, eg.

```SQL
SELECT FROM Person WHERE name = 'foo' AND surname in ['xxx', 'yyy']
```

This query can be optimized using an index defined on `name` and `surname`.

As a general rule, `IN` conditions are optimized using indexes only when all these conditions apply:
- the index can be used for a full match (not on partial match)
- the `IN` condition is defined on the last property in the index definition

In all the other cases, the `IN` condition is not optimized using indexes


## Case I - order of conditions in the WHERE clause

In v 2.2, OrientDB SQL executor tries to find the best index based on the conditions defined in the query, but in some cases if fails to find the right combination of conditions to consider for indexed execution. 

An important rule to make OrientDB find the right index (and use it the right way) is to write the conditions in the same order as the properties appear in the index definition.

Consider the schema and index defined in Case E, a query like following

```SQL
SELECT FROM Person WHERE name = 'foo' AND surname = 'bar' AND age = 25 
```

Will correctly use the index on all the three properties. A query like following

```SQL
//wrong order of properties
SELECT FROM Person WHERE surname = 'bar' AND age = 25 AND name = 'foo'
```

in some cases will only use the index to match the `name` and then will manually filter on `surname` and `age`


This is particularly relevant when using parentheses, eg. the following query 

```SQL
//wrong order of properties + parentheses
SELECT FROM Person WHERE (surname = 'bar' AND age = 25) AND (name = 'foo')
```

will likely fail to correctly use the index

> **IMPORTANT**: always try to write your WHERE clause so that the order of the conditions matches the order of the fields in the index definition, this will make it easier for OrientDB to find the right index and use it correctly. 

> **NOTE**: this limitation is completely removed in v 3.0


## Understanding EXPLAIN command

EXPLAIN is a very useful tool to understand how a query is performing. To use it, just prefix the query with `explain` keyword, eg.

```
EXPLAIN SELECT FROM Person WHERE name = 'foo'
```

The result is a record containing statistics about the query execution, eg.

```json
{
    "result": [
        {
            "@type": "d",
            "@version": 0,
            "documentReads": 2,
            "fullySortedByIndex": false,
            "documentAnalyzedCompatibleClass": 2,
            "recordReads": 2,
            "fetchingFromTargetElapsed": 0,
            "indexIsUsedInOrderBy": false,
            "compositeIndexUsed": 1,
            "current": "#74:0",
            "involvedIndexes": [
                "Person.name_surname_age_karma"
            ],
            "limit": -1,
            "evaluated": 2,
            "user": "#5:0",
            "elapsed": 0.655,
            "resultType": "collection",
            "resultSize": 1
        }
    ]
}
```
