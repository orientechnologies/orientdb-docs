---
search:
   keywords: ['SQL']
---

# SQL

When it comes to query languages, SQL is the mostly widely recognized standard. The majority of developers have experience and are comfortable with SQL. For this reason Orient DB uses SQL as it's query language and adds some extensions to enable graph functionality. There are a few differences between the standard SQL syntax and that supported by OrientDB, but for the most part, it should feel very natural. The differences are covered in the [OrientDB SQL dialect](#orientdb-sql-dialect) section of this page.

Many SQL commands share the [WHERE condition](SQL-Where.md). Keywords and class names in OrientDB SQL are case insensitive. Field names and values are case sensitive. In the following examples keywords are in uppercase but this is not strictly required.

If you are not yet familiar with SQL, we suggest you to get the course on [KhanAcademy](http://cs-blog.khanacademy.org/2015/05/just-released-full-introductory-sql.html).

For example, if you have a class `MyClass` with a field named `id`, then the following SQL statements are equivalent:

```sql
SELECT FROM MyClass WHERE id = 1
select from myclass where id = 1
```

The following is NOT equivalent.  Notice that the field name 'ID' is not the same as 'id'.

```sql
SELECT FROM MyClass WHERE ID = 1
```

## Automatic usage of indexes

OrientDB allows you to execute queries against any field, indexed or not-indexed. The SQL engine automatically recognizes if any indexes can be used to speed up execution. You can also query any indexes directly by using `INDEX:<index-name>` as a target. Example:

```sql
SELECT FROM INDEX:myIndex WHERE key = 'Jay'
```

## Extra resources
- [SQL expression syntax](SQL-Where.md)
 - [Where clause](SQL-Where.md)
 - [Operators](SQL-Where.md#operators)
 - [Functions](SQL-Where.md#functions)
- [Pagination](Pagination.md)
- [Pivoting-With-Query](Pivoting-With-Query.md)
- [SQL batch](SQL-batch.md)

## OrientDB SQL dialect

OrientDB supports SQL as a query language with some differences compared with SQL. Orient Technologies decided to avoid creating Yet-Another-Query-Language. Instead we started from familiar SQL with extensions to work with graphs. We prefer to focus on standards.

If you want learn SQL, there are many online courses such as:
- [Online course Introduction to Databases by Jennifer Widom from Stanford university](https://www.coursera.org/course/db)
- [Introduction to SQL at W3 Schools](http://www.w3schools.com/sql/sql_intro.asp)
- [Beginner guide to SQL](https://blog.udemy.com/beginners-guide-to-sql/)
- [SQLCourse.com](http://www.sqlcourse2.com/intro2.html)
- [YouTube channel Basic SQL Training by Joey Blue](http://www.youtube.com/playlist?list=PLD20298E653A970F8)

To know more, look to [OrientDB SQL Syntax](SQL-Syntax.md).

Or order any book like [these](http://www.amazon.com/s/ref=nb_sb_noss/189-0251150-4407173?url=search-alias%3Daps&field-keywords=sql)

## JOINs
The most important difference between OrientDB and a Relational Database is that relationships are represented by `LINKS` instead of JOINs.

For this reason, the classic JOIN syntax is not supported. OrientDB uses the "dot (`.`) notation" to navigate `LINKS`. Example 1 : In SQL you might create a join such as:
```sql
SELECT *
FROM Employee A, City B
WHERE A.city = B.id
AND B.name = 'Rome'
```
In OrientDB, an equivalent operation would be:
```sql
SELECT * FROM Employee WHERE city.name = 'Rome'
```
This is much more straight forward and powerful! If you use multiple JOINs, the OrientDB SQL equivalent will be an even larger benefit. Example 2:  In SQL you might create a join such as:
```sql
SELECT *
FROM Employee A, City B, Country C,
WHERE A.city = B.id
AND B.country = C.id
AND C.name = 'Italy'
```
In OrientDB, an equivalent operation would be:
```sql
SELECT * FROM Employee WHERE city.country.name = 'Italy'
```

## Projections
In SQL, projections are mandatory and you can use the star character `*` to include all of the fields. With OrientDB this type of projection is optional. Example: In SQL to select all of the columns of Customer you would write:
```sql
SELECT * FROM Customer
```
In OrientDB, the `*` is optional:
```sql
SELECT FROM Customer
```

## DISTINCT
In SQL, `DISTINCT` is a keyword but in OrientDB it is a function, so if your query is:
```sql
SELECT DISTINCT name FROM City
```
In OrientDB, you would write:
```sql
SELECT DISTINCT(name) FROM City
```

## HAVING

OrientDB does not support the `HAVING` keyword, but with a nested query it's easy to obtain the same result. Example in SQL:
```SQL
SELECT city, sum(salary) AS salary
FROM Employee
GROUP BY city
HAVING salary > 1000
```

This groups all of the salaries by city and extracts the result of aggregates with the total salary greater than 1,000 dollars. In OrientDB the `HAVING` conditions go in a select statement in the predicate:

```SQL
SELECT FROM ( SELECT city, SUM(salary) AS salary FROM Employee GROUP BY city ) WHERE salary > 1000
```

## Select from multiple targets

OrientDB allows only one class (classes are equivalent to tables in this discussion) as opposed to SQL, which allows for many tables as the target.  If you want to select from 2 classes, you have to execute 2 sub queries and join them with the `UNIONALL` function:
```sql
SELECT FROM E, V
```
In OrientDB, you can accomplish this with a few variable definitions and by using the `expand` function to the union:
```sql
SELECT EXPAND( $c ) LET $a = ( SELECT FROM E ), $b = ( SELECT FROM V ), $c = UNIONALL( $a, $b )
```

## Query metadata
OrientDB provides the `metadata:` target to retrieve information about OrientDB's metadata:
- `schema`, to get classes and properties
- `indexmanager`, to get information about indexes

### Query the schema

Get all the configured classes:
```
select expand(classes) from metadata:schema

----+-----------+---------+----------------+----------+--------+--------+----------+----------+------------+----------
#   |name       |shortName|defaultClusterId|strictMode|abstract|overSize|clusterIds|properties|customFields|superClass
----+-----------+---------+----------------+----------+--------+--------+----------+----------+------------+----------
0   |UserGroup  |null     |13              |false     |false   |0.0     |[1]       |[2]       |null        |V
1   |WallPost   |null     |15              |false     |false   |0.0     |[1]       |[4]       |null        |V
2   |Owner      |null     |12              |false     |false   |0.0     |[1]       |[1]       |null        |E
3   |OTriggered |null     |-1              |false     |true    |0.0     |[1]       |[0]       |null        |null
4   |E          |E        |10              |false     |false   |0.0     |[1]       |[0]       |null        |null
5   |OUser      |null     |5               |false     |false   |0.0     |[1]       |[4]       |null        |OIdentity
6   |OSchedule  |null     |7               |false     |false   |0.0     |[1]       |[7]       |null        |null
7   |ORestricted|null     |-1              |false     |true    |0.0     |[1]       |[4]       |null        |null
8   |AssignedTo |null     |11              |false     |false   |0.0     |[1]       |[1]       |null        |E
9   |V          |null     |9               |false     |false   |2.0     |[1]       |[0]       |null        |null
10  |OFunction  |null     |6               |false     |false   |0.0     |[1]       |[5]       |null        |null
11  |ORole      |null     |4               |false     |false   |0.0     |[1]       |[4]       |null        |OIdentity
12  |ORIDs      |null     |8               |false     |false   |0.0     |[1]       |[0]       |null        |null
13  |OIdentity  |null     |-1              |false     |true    |0.0     |[1]       |[0]       |null        |null
14  |User       |null     |14              |false     |false   |0.0     |[1]       |[2]       |null        |V
----+-----------+---------+----------------+----------+--------+--------+----------+----------+------------+----------
```

Get all the configured properties for the class OUser:

```

select expand(properties) from (
   select expand(classes) from metadata:schema
) where name = 'OUser'

----+--------+----+---------+--------+-------+----+----+------+------------+-----------
#   |name    |type|mandatory|readonly|notNull|min |max |regexp|customFields|linkedClass
----+--------+----+---------+--------+-------+----+----+------+------------+-----------
0   |status  |7   |true     |false   |true   |null|null|null  |null        |null
1   |roles   |15  |false    |false   |false  |null|null|null  |null        |ORole
2   |password|7   |true     |false   |true   |null|null|null  |null        |null
3   |name    |7   |true     |false   |true   |null|null|null  |null        |null
----+--------+----+---------+--------+-------+----+----+------+------------+-----------

```

Get only the configured `customFields` properties for OUser (assuming you added CUSTOM metadata like foo=bar):

```
select customFields from (
    select expand(classes) from metadata:schema 
) where name="OUser"


----+------+------------
#   |@CLASS|customFields
----+------+------------
0   |null  |{foo=bar}
----+------+------------

```

Or, if you wish to get only the configured `customFields`  of an attribute, like if you had a comment for the password attribute for the OUser class. 

```
select customFields from (
  select expand(properties) from (
     select expand(classes) from metadata:schema 
  ) where name="OUser"
) where name="password"


----+------+----------------------------------------------------
#   |@CLASS|customFields
----+------+----------------------------------------------------
0   |null  |{comment=Foo Bar your password to keep it secure!}
----+------+----------------------------------------------------

```

### Query the available indexes

Get all the configured indexes:

```
select expand(indexes) from metadata:indexmanager

----+------+------+--------+---------+---------+------------------------------------+------------------------------------------------------
#   |@RID  |mapRid|clusters|type     |name     |indexDefinition                     |indexDefinitionClass
----+------+------+--------+---------+---------+------------------------------------+------------------------------------------------------
0   |#-1:-1|#2:0  |[0]     |DICTIO...|dictio...|{keyTypes:[1]}                      |com.orientechnologies.orient.core.index.OSimpleKeyI...
1   |#-1:-1|#1:1  |[1]     |UNIQUE   |OUser....|{className:OUser,field:name,keyTy...|com.orientechnologies.orient.core.index.OPropertyIn...
2   |#-1:-1|#1:0  |[1]     |UNIQUE   |ORole....|{className:ORole,field:name,keyTy...|com.orientechnologies.orient.core.index.OPropertyIn...
----+------+------+--------+---------+---------+------------------------------------+-----------------------------------------
```
