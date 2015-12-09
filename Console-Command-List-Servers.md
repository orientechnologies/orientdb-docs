# Console - `LIST SERVERS`

Displays all active servers connected in a cluster.

>This command was introduced in OrientDB version 2.2.

**Syntax:**

```sql
LIST SERVERS
```
**Example:**

- List the servers currently connected to the cluster:

  <pre>
  orientdb> <code class="lang-sql userinput">LIST SERVERS</code>

  CONFIGURED SERVERS
  -+----+------+-----------+-------------+-----------+-----------+-----------+----------+---------
  #|Name|Status|Connections|StartedOn     |Binary    |HTTP       |UsedMemory |FreeMemory|MaxMemory
  -+----+------+-----------+-------------+-----------+-----------+-----------+----------+---------
  0|no2 |ONLINE|0          |2015-10-30...|192.168.0.6|192.168.0.6|80MB(8.80%)|215MB(23%)|910MB 
  1|no1 |ONLINE|0          |2015-10-30...|192.168.0.6|192.168.0.6|90MB(2.49%)|195MB(5%) |3.5GB   
  -+----+------+-----------+-------------+-----------+-----------+-----------+----------+---------
  </pre>

- Use the [`DISPLAY`](Console-Command-Display-Record.md) command to show information on a specific server:

  <pre>
  orientdb> <code class="lang-sql userinput">DISPLAY 0</code>
  -------------+------------------------------
          Name | Value                        
  -------------+------------------------------
          Name | node2
        Status | ONLINE
   Connections | 0
     StartedOn | Fri Oct 30 21:41:07 CDT 2015
        Binary | 192.168.0.6:2425 
          HTTP | 192.168.0.6:2481
    UsedMemory | 80,16MB (8,80%)
    FreeMemory | 215,34MB (23,65%)
     MaxMemory | 910,50MB
  -------------+------------------------------
  </pre>

>For more information about other commands available, see [Console Commands](Console-Commands.md)
