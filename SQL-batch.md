# SQL Batch

OrientDB allows execution of arbitrary scripts written in Javascript or any scripting language installed in the JVM. OrientDB supports a minimal SQL engine to allow a batch of commands.

Batch of commands are very useful when you have to execute multiple things at the server side avoiding the network roundtrip for each command.

SQL Batch supports all the OrientDB [SQL commands](SQL.md), plus the following:
- ```begin [isolation <isolation-level>]```, where `<isolation-level>` can be `READ_COMMITTED`, `REPEATABLE_READ`. By default is `READ_COMMITTED`
- ```commit [retry <retry>]```, where:
 - <retry> is the number of retries in case of concurrent modification exception
- ```let <variable> = <SQL>```, to assign the result of a SQL command to a variable. To reuse the variable prefix it with the dollar sign $
- ```if(<expression>){<statememt>}```. Look at [Conditional execution](SQL-batch.md#conditional-execution).
- ```sleep <ms>```, put the batch in wait for `<ms>` milliseconds.
- ```console.log <text>```, logs a message in the console. Context variables can be used with `${<variable>}`. Since 2.2.
- ```console.error <text>```, writes a message in the console's standard output. Context variables can be used with `${<variable>}`. Since 2.2.
- ```console.output <text>```, writes a message in the console's standard error. Context variables can be used with `${<variable>}`. Since 2.2.
- ```return``` <value>, where value can be:
 - any value. Example: ```return 3```
 - any variable with $ as prefix. Example: ```return $a```
 - arrays. Example: ```return [ $a, $b ]```
 - maps. Example: ```return { 'first' : $a, 'second' : $b }```

## See also
- [Javascript-Command](Javascript-Command.md)

## Optimistic transaction

Example to create a new vertex in a [Transaction](Transactions.md) and attach it to an existent vertex by creating a new edge between them. If a concurrent modification occurs, repeat the transaction up to 100 times:

```sql
begin
let account = create vertex Account set name = 'Luke'
let city = select from City where name = 'London'
let edge = create edge Lives from $account to $city
commit retry 100
return $edge
```

Note the usage of $account and $city in further SQL commands.

## Pessimistic transaction

This script above used an Optimistic approach: in case of conflict it retries up top 100 times by re-executing the entire transaction (commit retry 100). To follow a Pessimistic approach by locking the records, try this:

```sql
BEGIN
let account = CREATE VERTEX Account SET name = 'Luke'
let city = SELECT FROM City WHERE name = 'London' LOCK RECORD
let edge = CREATE EDGE Lives FROM $account TO $city
COMMIT
return $edge
```

Note the "lock record" after the select. This means the returning records will be locked until commit (or rollback). In this way concurrent updates against London will wait for this [transaction](Transactions.md) to complete.

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

## Java API

This can be used by Java API with:
```java
database.open("admin", "admin");

String cmd = "begin\n";
cmd += "let a = CREATE VERTEX SET script = true\n";
cmd += "let b = SELECT FROM v LIMIT 1\n";
cmd += "let e = CREATE EDGE FROM $a TO $b\n";
cmd += "COMMIT RETRY 100\n";
cmd += "return $e";

OIdentifiable edge = database.command(new OCommandScript("sql", cmd)).execute();
```

Remember to put one command per line (postfix it with \n) or use the semicolon (;) as separator.

## HTTP REST API

And via HTTP REST interface (https://github.com/orientechnologies/orientdb/issues/2056). Execute a POST against /batch URL by sending a payload in this format:

```json
{ "transaction" : false,
  "operations" : [
    {
      "type" : "script",
      "language" : "sql",
      "script" : <text>
    }
  ]
}
```

Example:

```json
{ "transaction" : false,
  "operations" : [
    {
      "type" : "script",
      "language" : "sql",
      "script" : [ "BEGIN;let account = CREATE VERTEX Account SET name = 'Luke';let city =SELECT FROM City WHERE name = 'London';CREATE EDGE Lives FROM $account TO $city;COMMIT RETRY 100" ]
    }
  ]
}
```

To separate commands use semicolon (;) or linefeed (\n). Starting from release 1.7 the "script" property can be an array of strings to put each command on separate item, example:
```json
{ "transaction" : false,
  "operations" : [
    {
      "type" : "script",
      "language" : "sql",
      "script" : [ "begin",
                   "let account = CREATE VERTEX Account SET name = 'Luke'",
                   "let city = SELECT FROM City WHERE name = 'London'",
                   "CREATE EDGE Lives FROM $account TO $city",
                   "COMMIT RETRY 100" ]
    }
  ]
}
```

Hope this new feature will simplify your development improving performance.

What about having more complex constructs like IF, FOR, etc? If you need more complexity, we suggest you to use Javascript as language that already support all these concepts.
