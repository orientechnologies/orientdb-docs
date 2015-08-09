# Console - LIST CLASSES

Displays all the classes configured in the current database.

## Syntax

```
LIST CLASSES
```

## Example

```sql
LIST CLASSES

CLASSES
--------------------+------+------------------------------------------+-----------+
NAME                |  ID  | CLUSTERS                                 | ELEMENTS  |
--------------------+------+------------------------------------------+-----------+
Person              |     0| person                                   |         7 |
Animal              |     1| animal                                   |         5 |
AnimalRace          |     2| AnimalRace                               |         0 |
AnimalType          |     3| AnimalType                               |         1 |
OrderItem           |     4| OrderItem                                |         0 |
Order               |     5| Order                                    |         0 |
City                |     6| City                                     |         3 |
--------------------+------+------------------------------------------+-----------+
TOTAL                                                                          16 |
----------------------------------------------------------------------------------+
```

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
