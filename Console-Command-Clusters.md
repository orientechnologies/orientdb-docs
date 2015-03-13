# Console - CLUSTERS

Displays all the clusters configured in the current database.

## Syntax

```
clusters
```

## Example

```java
> clusters

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
```

## See also

To create a new cluster in the current database use the command [create cluster](Console-Command-Create-Cluster.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
