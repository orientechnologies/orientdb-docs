---
search:
   keywords: ['SQL', 'HA SET', 'HA', 'high availability', 'owner', 'server', 'role']
---

# SQL - `HA SET`

(Since v2.2.22, Enterprise Edition only). Update the server configuration in High Availability setting.

**Syntax**

```
HA SET [DBSTATUS <server>=<status>] [ROLE <server>=MASTER|REPLICA] [OWNER <cluster>=<server>]
```

NOTE: *the key/value pairs must not contain any space. This is valid `HA SET ROLE europe=REPLICA`, this is not: `HA SET ROLE europe = REPLICA`*

- **DBSTATUS** Changes the status of the database. This operation must be executed only if recommended by OrientDB Support Team
 - **`<server>`** Server name.
 - **`<status>`** The new status to set between `[NOT_AVAILABLE, OFFLINE, SYNCHRONIZING, ONLINE, BACKUP]`.
- **ROLE** Changes the role of the server between `MASTER` and `REPLICA`
 - **`<server>`** Server name.
- **OWNER** Changes cluster's owner
 - **`<cluster>`** The name of the cluster to change.
 - **`<server>`** Name of the server to become the owner of the cluster. The server name must be already present in the server list for that cluster.


**Examples**

- Change the role of the server `europe` to be a `REPLICA` only:

  <pre>
  orientdb> <code class='lang-sql userinput'>HA SET ROLE europe=REPLICA</code>
  </pre>

- Set the server `usa0` as the owner of cluster "customer":

  <pre>
  orientdb> <code class='lang-sql userinput'>HA SET OWNER customer=usa0</code>
  </pre>
  
- Set the status of database `crm` to OFFLINE for server `china`:

  <pre>
  orientdb> <code class='lang-sql userinput'>HA SET DBSTATUS china=OFFLINE</code>
  </pre>

  
>For more information, see
>- [Distributed Architecture](Distributed-Architecture.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](/console/Console-Commands.md)
