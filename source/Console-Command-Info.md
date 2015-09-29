# Console - INFO

Displays all the information about the current database.

## Syntax

```
INFO
```

## Example

```java
Current database: ../databases/petshop/petshop
CLUSTERS:
--------------------+------+--------------------+-----------+
NAME                |  ID  | TYPE               | ELEMENTS  |
--------------------+------+--------------------+-----------+
metadata            |     0|Physical            |        11 |
index               |     1|Physical            |         0 |
default             |     2|Physical            |       779 |
csv                 |     3|Physical            |      1000 |
binary              |     4|Physical            |      1001 |
person              |     5|Physical            |         7 |
animal              |     6|Physical            |         5 |
animalrace          |    -2|Logical             |         0 |
animaltype          |    -3|Logical             |         1 |
orderitem           |    -4|Logical             |         0 |
order               |    -5|Logical             |         0 |
city                |    -6|Logical             |         3 |
--------------------+------+--------------------+-----------+
TOTAL                                                  2807 |
------------------------------------------------------------+

CLASSES:
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
