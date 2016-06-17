## SQL Projections

A projection is a value that is returned by a query statement (SELECT, MATCH).

Eg. the following query

```sql
SELECT name as firstName, age * 12 as ageInMonths, out("Friend") from Person where surname = 'Smith'
```

has three projections:

- `name as firstName`
- `age * 12 as ageInMonths`
- `out("Friend")`

### Syntax

**A projection** has the following syntax:

`<expression> [ AS <alias> ]`

- `<expression>` is an expression (see [SQL Syntax](SQL-Syntax.md)) that represents the way to calculate the value of the single projection
- `<alias>` is the Identifier (see [SQL Syntax](SQL-Syntax.md)) representing the field name used to return the value in the result set

A projection block has the following syntax:

`[DISTINCT] <projection> [, <projection> ]*`

- `DISTINCT`: removes duplicates from the result-set

*IMPORTANT - the old `distinct()` function (used in OrientDB <=2.x) is no longer supported*


### Expansion

By default, a query returns a different result-set based on the projections it has:
- **`*` alone**: The result set is made of records as they arrive from the target, with the original @rid and @class attributes (if any)
- **`*` plus other projections**: records of the original target, merged with the other projection values, with temporary @rid and no @class (if not explicitly declared in the other projections)
- **no projections**: same behavior as `*`
- **`expand(<projection>)`**:
- **one or more projections**: temporary records (with temporary @rid and no @class). Projections that represent links are returned as simple @rid values, unless differently specified in the fetchplan.

*IMPORTANT - projection values can be overwritten in the final result, the overwrite happens from left to right*
eg.
```sql
SELECT 1 as a, 2 as a 
```
will return `{"@rid": "-2:0", "a":2}`

eg.

Having the record `{"@class":"Foo", "name":"bar", "@rid":"#12:0"}`

```sql
SELECT *, "hey" as name from Foo
```
will return `{"@rid": "-2:0", "name":"hey"}`

```sql
SELECT  "hey" as name, * from Foo
```
will return  `{"@rid": "-2:0", "name":"bar"}`

*IMPORTANT - the result of the query can be further unwinded using the UNWIND operator*
