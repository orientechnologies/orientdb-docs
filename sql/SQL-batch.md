---
search:
   keywords: ['SQL', 'BATCH']
---

# SQL Batch

OrientDB allows execution of arbitrary scripts written in Javascript or any scripting language installed in the JVM. OrientDB supports a minimal SQL engine to allow a batch of commands.

Batch of commands are very useful when you have to execute multiple things at the server side avoiding the network roundtrip for each command.

SQL Batch supports all the OrientDB [SQL Commands](SQL-Commands.md), plus the following:
- ```begin [isolation <isolation-level>]```, where `<isolation-level>` can be `READ_COMMITTED`, `REPEATABLE_READ`. By default is `READ_COMMITTED`
- ```commit [retry <retry>]```, where:
 - <retry> is the number of retries in case of concurrent modification exception
- ```let <variable> = <SQL>```, to assign the result of a SQL command to a variable. To reuse the variable prefix it with the dollar sign $
- ```IF(<condition>){ <statememt>; [<statement>;]* }```. Look at [Conditional execution](SQL-batch.md#conditional-execution).
- ```WHILE(<condition>){ <statememt>; [<statement>;]* }```. Look at [Conditional execution](SQL-batch.md#Loops).
- ```FOREACH(<variable> IN <expression>){ <statememt>; [<statement>;]* }```. Look at [Conditional execution](SQL-batch.md#Loops).
- ```SLEEP <ms>```, put the batch in wait for `<ms>` milliseconds.
- ```console.log <text>```, logs a message in the console. Context variables can be used with `${<variable>}`. Since 2.2.
- ```console.error <text>```, writes a message in the console's standard output. Context variables can be used with `${<variable>}`. Since 2.2.
- ```console.output <text>```, writes a message in the console's standard error. Context variables can be used with `${<variable>}`. Since 2.2.
- ```return``` <value>, where value can be:
 - any value. Example: ```return 3```
 - any variable with $ as prefix. Example: ```return $a```
 - arrays (HTTP protocol only, see below). Example: ```return [ $a, $b ]```
 - maps (HTTP protocol only, see below). Example: ```return { 'first' : $a, 'second' : $b }```
 - a query. Example: ```return (SELECT FROM Foo)```  
 
 NOTE: to return arrays and maps (eg. Java or Node.js driver) it's strongly recommended to use a RETURN SELECT, eg.  

```
return (SELECT $a as first, $b as second)
```

This will work on any protocol and driver.


## Optimistic transaction

Example to create a new vertex in a [Transaction](../internals/Transactions.md) and attach it to an existent vertex by creating a new edge between them. If a concurrent modification occurs, repeat the transaction up to 100 times:

```sql
begin
let account = create vertex Account set name = 'Luke'
let city = select from City where name = 'London'
let e = create edge Lives from $account to $city
commit retry 100
return $e
```

Note the usage of $account and $city in further SQL commands.

## Pessimistic transaction

This script above used an Optimistic approach: in case of conflict it retries up top 100 times by re-executing the entire transaction (commit retry 100). To follow a Pessimistic approach by locking the records, try this:

```sql
BEGIN
let account = CREATE VERTEX Account SET name = 'Luke'
let city = SELECT FROM City WHERE name = 'London' LOCK RECORD
let e = CREATE EDGE Lives FROM $account TO $city
COMMIT
return $e
```

Note the "lock record" after the select. This means the returning records will be locked until commit (or rollback). In this way concurrent updates against London will wait for this [transaction](../internals/Transactions.md) to complete.

_NOTE: locks inside transactions works ONLY against MEMORY storage, we're working to provide such feature also against plocal. Stay tuned (Issue https://github.com/orientechnologies/orientdb/issues/1677)_


## Conditional execution 
(since 2.1.7)
SQL Batch provides IF constructor to allow conditional execution.
The syntax is

```sql
if(<sql-predicate>){
   <statement>
   <statement>
   ...
}
```
`<sql-predicate>` is any valid SQL predicate (any condition that can be used in a WHERE clause).
In current release it's mandatory to have `IF(){`, `<statement>` and `}` on separate lines, eg. the following is not a valid script

```sql
if($a.size() > 0) { ROLLBACK }
```
The right syntax is following:
```sql
if($a.size() > 0) { 
   ROLLBACK 
}
```

## Loops

SQL Batch provides two different loop blocks: FOREACH and WHILE

#### FOREACH

(since v 3.0.3 - experimental)

Loops on all the items of a collection and, for each of them, executes a set of SQL statements

The syntax is

```sql
FOREACH(<variable> IN <expression>){
   <statement>;
   <statement>;
   ...
}
```
Example
```sql
FOREACH ($i IN [1, 2, 3]){
  INSERT INTO Foo SET value = $i;
}
```


#### WHILE

(since v 3.0.3 - experimental)

Loops while a condition is true

The syntax is

```sql
WHILE(<condition>){
   <statement>;
   <statement>;
   ...
}
```

Example
```sql
LET $i = 0;
WHILE ($i < 10){
  INSERT INTO Foo SET value = $i;
  LET $i = $i + 1;
}
```



