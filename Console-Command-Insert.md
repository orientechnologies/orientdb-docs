# Console -  insert

# Insert

Insert a new record into the current database. Remember that Orient can work also in schema-less mode, so you can create any field at-the-fly.

## Syntax

```
insert into <class|cluster:<cluster>> (<field-name>*) values ( <field-value> )
```

## Example

nsert a new record with name 'Jay' and surname 'Miner':

```java
> insert into Profile (name, surname) values ('Jay', 'Miner' )

Inserted record in 0,060000 sec(s).
```


Insert a new record adding a relationship:

```java
insert into Employee (name, boss) values ('jack', 11:99 )
```

Insert a new record adding a collection of relationship:

```java
insert into Profile (name, friends) values ('Luca', [10:3, 10:4] )
```

To know more about the SQL syntax used in Orient take a look to: [SQL-Query](SQL-Query.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
