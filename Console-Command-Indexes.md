# Console - INDEXES

Displays all the index in current database.

## Syntax

```sql
INDEXES
```

## Example

```sql
orientdb {db=GratefulDeadConcerts}> indexes

INDEXES
----------------------------------------------+------------+-----------------------+----------------+------------+
 NAME                                         | TYPE       |         CLASS         |     FIELDS     | RECORDS    |
----------------------------------------------+------------+-----------------------+----------------+------------+
 dictionary                                   | DICTIONARY |                       |                |          0 |
 Group.Grp_Id                                 | UNIQUE     | Group                 | Grp_Id         |          1 |
 ORole.name                                   | UNIQUE     | ORole                 | name           |          3 |
 OUser.name                                   | UNIQUE     | OUser                 | name           |          4 |
----------------------------------------------+------------+-----------------------+----------------+------------+
 TOTAL = 4                                                                                                     8 |
-----------------------------------------------------------------------------------------------------------------+
```

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
