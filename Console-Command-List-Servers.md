# Console - LIST SERVERS

(Since v2.2)

Displays all the active servers connected in cluster.

## Syntax

```sql
LIST SERVERS
```

## Example

```sql
orientdb> list servers
CONFIGURED SERVERS
----+-----+------+-----------+-------------------+----------------+----------------+---------------+-----------------+---------
#   |Name |Status|Connections|StartedOn          |Binary          |HTTP            |UsedMemory     |FreeMemory       |MaxMemory
----+-----+------+-----------+-------------------+----------------+----------------+---------------+-----------------+---------
0   |node2|ONLINE|0          |2015-10-30 21:41:07|192.168.0.6:2425|192.168.0.6:2481|80,16MB (8,80%)|215,34MB (23,65%)|910,50MB 
1   |node1|ONLINE|0          |2015-10-30 18:34:07|192.168.0.6:2424|192.168.0.6:2480|90,50MB (2,49%)|195,50MB (5,37%) |3,56GB   
----+-----+------+-----------+-------------------+----------------+----------------+---------------+-----------------+---------

orientdb {db=DatabaseUniqueIndexIssueTest4}> display 0

+--------------------------+----------------------------------------------------------------------+
|                     Name | Value                                                                |
+--------------------------+----------------------------------------------------------------------+
|                     Name | node2                                                                |
|                   Status | ONLINE                                                               |
|              Connections | 0                                                                    |
|                StartedOn | Fri Oct 30 21:41:07 CDT 2015                                         |
|                   Binary | 192.168.0.6:2425                                                     |
|                     HTTP | 192.168.0.6:2481                                                     |
|               UsedMemory | 80,16MB (8,80%)                                                      |
|               FreeMemory | 215,34MB (23,65%)                                                    |
|                MaxMemory | 910,50MB                                                             |
+-------------------------------------------------------------------------------------------------+
```

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
