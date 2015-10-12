# Console - LIST CONNECTIONS

(Since v2.2)

Displays all the active connections to the OrientDB server.

## Syntax

```sql
LIST CONNECTIONS
```

## Example

```sql
orientdb {server=remote:localhost/}> list connections

----+----+----------------------+------+-------------------+--------+-----+-------------------------------------------------------+--------
#   |ID  |REMOTE_ADDRESS        |PROTOC|LAST_OPERATION_ON  |DATABASE|USER |COMMAND                                                |TOT_REQS
----+----+----------------------+------+-------------------+--------+-----+-------------------------------------------------------+--------
0   |17  |/127.0.0.1:51406      |binary|2015-10-12 19:22:34|-       |-    |Server Info                                            |1       
1   |4   |/0:0:0:0:0:0:0:1:51379|http  |2015-10-12 19:19:58|pokec   |admin|Command (select AGE,count(*) from Profile group by AGE)|7       
2   |16  |/127.0.0.1:51406      |binary|1970-01-01 01:00:00|-       |-    |-                                                      |0       
3   |1   |/0:0:0:0:0:0:0:1:51359|http  |1970-01-01 00:59:59|pokec   |admin|Listening                                              |32      
----+----+----------------------+------+-------------------+--------+-----+-------------------------------------------------------+--------

```

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
