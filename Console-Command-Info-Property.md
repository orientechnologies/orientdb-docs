# Console - INFO PROPERTY

Displays all the information about the selected property.

## Syntax

```
INFO PROPERTY <class-name>.<property-name>
```

## Example

```sql
orientdb {db=GratefulDeadConcerts}> info property OUser.name

PROPERTY 'OUser.name'

Type.................: STRING
Mandatory............: true
Not null.............: true
Read only............: false
Default value........: null
Minimum value........: null
Maximum value........: null
REGEXP...............: null
Collate..............: {OCaseInsensitiveCollate : name = ci}
Linked class.........: null
Linked type..........: null

INDEXES (1 altogether)
-------------------------------+----------------+
 NAME                          | PROPERTIES     |
-------------------------------+----------------+
 OUser.name                    | name           |
-------------------------------+----------------+
```


This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).


