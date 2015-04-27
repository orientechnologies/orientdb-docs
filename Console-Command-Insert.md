# Console -  INSERT

# INSERT

Insert a new record into the current database. Remember that Orient can work also in schema-less mode, so you can create any field at-the-fly.

## Syntax

```
INSERT INTO <class|cluster:<cluster>> (<field-name>*) VALUES ( <field-value> )
```

## Example

nsert a new record with name 'Jay' and surname 'Miner':

```sql
INSERT INTO Profile (name, surname) VALUES ('Jay', 'Miner' )

Inserted record in 0,060000 sec(s).
```


Insert a new record adding a relationship:

```sql
INSERT INTO Employee (name, boss) VALUES ('jack', 11:99 )
```

Insert a new record adding a collection of relationship:

```sql
INSERT INTO Profile (name, friends) VALUES ('Luca', [10:3, 10:4] )
```

To know more about the SQL syntax used in Orient take a look to: [SQL-Query](SQL-Query.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
