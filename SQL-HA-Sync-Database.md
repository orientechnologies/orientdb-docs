# SQL - `HA SYNC DATABASE`

Asks for a re-synchronization of the current database when running in HA. OrientDB will select the best server where to synchronize the database.

**Syntax**

```
HA SYNC DATABASE
```

**Examples**

- Re-synchronize the database:

  <pre>
  orientdb> <code class='lang-sql userinput'>HA SYNC DATABASE</code>
  </pre>

>For more information, see
>- [`HA SYNC CLUSTER`](SQL-HA-Sync-Cluster.md)
>- [Distributed Architecture](Distributed-Architecture.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)
