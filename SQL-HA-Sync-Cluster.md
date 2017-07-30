---
search:
   keywords: ['SQL', 'HA SYNC CLUSTER', 'HA', 'high availability', 'sync', 'cluster', 'sync cluster']
---

# SQL - `HA SYNC CLUSTER`

(Since v2.2) Asks for a re-synchronization of a cluster when running in HA. OrientDB will select the best server to provide the cluster.

**Warning:** starting from version 2.2.25, `HA SYNC CLUSTER <cluster-name>` will trigger an automatic rebuild of the indices defined on the Class the cluster `<cluster-name>` belongs to. Depending on the number of defined indices and amount of data included in the Class this operation can take some time. Furthermore it is important to wait that the sync cluster operation has finished before performing any database operations that involve that cluster.

**Syntax**

```
HA SYNC CLUSTER <cluster-name>
```

- **`<cluster-name>`** Defines the cluster name to re-synchronize.


**Examples**

- Re-synchronize the cluster `profile`:

  <pre>
  orientdb> <code class='lang-sql userinput'>HA SYNC CLUSTER profile</code>
  </pre>

>For more information, see
>- [`HA SYNC DATABASE`](SQL-HA-Sync-Database.md)
>- [Distributed Architecture](Distributed-Architecture.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)
