
{% include "./include-warning-3.0.md" %}

## SQL Changes

### DISTINCT keyword

In v 2.2 the only way to have distinct values from a SELECT statement was using the `distinct()` function. 
In v 3.0 we introduced `DISTINCT` operator, that is much more flexible than `distinct()` function.
The following query is valid in v 3.0
 
```sql
SELECT DISTINCT name, surname from Person
```

`distinct()` function is still allowed, but it's deprecated

### eval() and mathematical expressions
 
Until v 2.2 the only way to execute mathematical operations in SQL was to use `eval(expression)` function:

```select
SELECT eval(' 3 + 2 ') as sum
```

In v 3.0 mathematical expressions are allowed in both projections and WHERE conditions, eg.

```select
SELECT 3 + 2 as sum

SELECT FROM V WHERE theNumber > 3 + 3
```

Please refer to [SQL syntax](../../sql/SQL-Syntax.md) page for all the details 


### MATCH and DISTINCT

In v.2.2 the MATCH statement automatically filters duplicate result rows and there is no way
to specify a different behavior.

In v 3.0 the MATCH by default ALLOWS duplicate results, if you want only distinct results you have
to explicitly declare `RETURN DISTINCT ...`

The following statement in v.2.2

```
MATCH 
  {class:Person, as:a} -FriendOf-> {as:b}
RETURN a.name, b.name
```

is equivalent to v. 3.0

```
MATCH 
  {class:Person, as:a} -FriendOf-> {as:b}
RETURN DISTINCT a.name, b.name
```

### Changes in the CREATE INDEX statement
```sql
CREATE INDEX T.id UNIQUE
``` 
is not allowed anymore, please use 
```
CREATE INDEX T.id ON T(id) UNIQUE
``` 

instead

### Changes in the way batch script commands are separated

In v. 2.2 the newline is a valid statement separator in batch scripts.
Since 3.0 the only valid statement separator is the semicolon `;`.

In v 3.0 the following script is invalid

```sql
SELECT FROM V
SELECT FROM E
```

The following script is valid as well

```sql
SELECT FROM V
WHERE name = 'foo';
SELECT FROM E;
```

Please note that the first statement is split on two rows.

### EXPLAIN
BREAKING CHANGE: in v. 3.0 the EXPLAIN statement does not execute the statement anymore and does not
return information about execution statistics.

The EXPLAIN statement in v 3.0 returns details about the execution planning for the query, ie. all the steps
that the query executor will execute to calculate the query result.

### Changes in the CREATE EDGE statement

Starting from 3.0, it is mandatory to create the Edge class before executing the CREATE EDGE statement. If the Edge class does not exist the CREATE EDGE statement will fail (previously it was creating the Edge class automatically).

### Changes in the DELETE EDGE statement

Starting from 3.0, it is mandatory to specify in the DELETE EDGE statement the Edge class of the edge instance you want to delete. If the Edge class is not specified the DELETE EDGE statement will fail.
So if until 2.2.x Edge class is optional and you can execute something like
```
delete edge where out=#9:0 and in=#10:1
```
in 3.0 Edge Class is mandatory:
```
delete edge <Edge-Class-Name> where out=#9:0 and in=#10:1
```
If you don't want to get bored in remembering your class hierarchy you can simply specify the 'E' Edge Class.
```
delete edge E where out=#9:0 and in=#10:1
```
