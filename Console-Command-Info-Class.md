# Console - INFO CLASS

Displays all the information about the selected class.

## Syntax

```
INFO CLASS <class-name>
```

## Example

```sql
INFO CLASS Profile

CLASS 'Profile'

Default cluster......: profile (id=10)
Supported cluster ids: [10]
Properties:
-------------------------------+----+-------------+-------------------------------+-----------+-----------+----------+------+------+
 NAME                          | ID | TYPE        | LINKED TYPE/CLASS             | INDEX     | MANDATORY | NOT NULL | MIN  | MAX  |
-------------------------------+----+-------------+-------------------------------+-----------+-----------+----------+------+------+
 lastAccessOn                  |  5 | DATETIME    | null                          |           | false     | false    | 2010-01-01 00:00:00|      |
 registeredOn                  |  4 | DATETIME    | null                          |           | false     | false    | 2010-01-01 00:00:00|      |
 nick                          |  3 | STRING      | null                          |           | false     | false    | 3    | 30   |
 name                          |  2 | STRING      | null                          | NOTUNIQUE | false     | false    | 3    | 30   |
 surname                       |  1 | STRING      | null                          |           | false     | false    | 3    | 30   |
 photo                         |  0 | TRANSIENT   | null                          |           | false     | false    |      |      |
-------------------------------+----+-------------+-------------------------------+-----------+-----------+----------+------+------+
```


This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
