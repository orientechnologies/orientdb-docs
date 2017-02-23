---
search:
   keywords: ['SQL', 'HA SYNC CLUSTER', 'HA', 'high availability', 'sync', 'cluster', 'sync cluster']
---

# SQL - `HA SYNC CLUSTER`

(Since v2.2) Asks for a re-synchronization of a cluster when running in HA. OrientDB will select the best server to provide the cluster.

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
>- [Distributed Architecture](../Distributed-Architecture.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](../console/Console-Commands.md)
