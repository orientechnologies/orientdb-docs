---
search:
   keywords: ['SQL', 'HA SYNC DATABASE', 'HA', 'sync', 'database', 'sync database']
---

# SQL - `HA SYNC DATABASE`

(Since v2.2) Asks for a re-synchronization of the current database when running in HA. OrientDB will select the best server where to synchronize the database.

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
>- [Console Commands](console/Console-Commands.md)
