# SQL - `HA STATUS`

(Since v2.2) Retrieves information about HA.

**Syntax**

```
HA STATUS [-servers] [-db] [-all] [-output=text]
```

- **`-servers`** Dumps the configuration of servers
- **`-db`** Dumps the configuration of the database
- **`-latency`** Dumps the replication latency between servers (since v2.2.6)
- **`-messages`** Dumps the replication messages between servers (since v2.2.6)
- **`-all`** Dumps all the information
- **`-output=text`** Write the output as text formatted in readable tables


**Examples**

- Display the configuration of servers

  <pre>
  orientdb> <code class='lang-sql userinput'>HA STATUS -servers -output=text</code>

  Executed '
  +--------+------+------------------------+-----+---------+----------------+----------------+-----------------------+
  |Name    |Status|Databases               |Conns|StartedOn|Binary          |HTTP            |UsedMemory             |
  +--------+------+------------------------+-----+---------+----------------+----------------+-----------------------+
  |europe1*|ONLINE|testdb01=ONLINE (MASTER)|0    |16:31:44 |192.168.1.5:2425|192.168.1.5:2481|183.06MB/3.56GB (5.03%)|
  +--------+------+------------------------+-----+---------+----------------+----------------+-----------------------+
  ' in 0.002000 sec(s).
  </pre>

- Display the configuration of the current database

  <pre>
  orientdb> <code class='lang-sql userinput'>HA STATUS -db -output=text</code>
  Executed '
  LEGEND: X = Owner, o = Copy
  +-----------+-----------+----------+-------+-------+
  |           |           |          |MASTER |MASTER |
  |           |           |          |ONLINE |ONLINE |
  +-----------+-----------+----------+-------+-------+
  |CLUSTER    |writeQuorum|readQuorum|europe1|europe0|
  +-----------+-----------+----------+-------+-------+
  |*          |     2     |    1     |   X   |       |
  |data_1     |     2     |    1     |   o   |   X   |
  |data_2     |     2     |    1     |   o   |   X   |
  |data_3     |     2     |    1     |   o   |   X   |
  |data_4     |     2     |    1     |   o   |   X   |
  |e_4        |     2     |    1     |   o   |   X   |
  |e_5        |     2     |    1     |   o   |   X   |
  |e_6        |     2     |    1     |   o   |   X   |
  |e_7        |     2     |    1     |   o   |   X   |
  |internal   |     2     |    1     |       |       |
  |ofunction_0|     2     |    1     |   o   |   X   |
  |orole_0    |     2     |    1     |   o   |   X   |
  |oschedule_0|     2     |    1     |   o   |   X   |
  |osequence_0|     2     |    1     |   o   |   X   |
  |ouser_0    |     2     |    1     |   o   |   X   |
  |person     |     2     |    1     |   o   |   X   |
  |person_1   |     2     |    1     |   o   |   X   |
  |person_6   |     2     |    1     |   o   |   X   |
  |person_7   |     2     |    1     |   o   |   X   |
  |v_3        |     2     |    1     |   o   |   X   |
  |v_5        |     2     |    1     |   o   |   X   |
  |v_6        |     2     |    1     |   o   |   X   |
  |v_7        |     2     |    1     |   o   |   X   |
  +-----------+-----------+----------+-------+-------+
  ' in 0.050000 sec(s).
  </pre>
  
- Display the replication latency between servers (Since v2.2.6)

  <pre>
  orientdb> <code class='lang-sql userinput'>HA STATUS -latency -output=text</code>

  Executed '
  REPLICATION LATENCY AVERAGE (in milliseconds)
  +-------+-----+------+-----+
  |Servers|node1|node2*|node3|
  +-------+-----+------+-----+
  |node1  |     |  0.60| 0.43|
  |node2* | 0.39|      | 0.38|
  |node3  | 0.35|  0.53|     |
  +-------+-----+------+-----+  
  ' in 0.023000 sec(s).
  </pre>
  
- Display the replication messages between servers (Since v2.2.6)

  <pre>
  orientdb> <code class='lang-sql userinput'>HA STATUS -messages -output=text</code>

  Executed '
  REPLICATION MESSAGES
  +-------+------+------+------+
  |Servers| node1|node2*| node3|
  +-------+------+------+------+
  |node1  |      |     9|     5|
  |node2* |64,476|      |53,593|
  |node3  |     5|     5|      |
  +-------+------+------+------+
  ' in 0.005000 sec(s).
  </pre>  
  
>For more information, see
>- [Distributed Architecture](Distributed-Architecture.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)
