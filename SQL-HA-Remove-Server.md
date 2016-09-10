---
search:
   keywords: ['SQL', 'HA REMOVE SERVER', 'HA', 'high availability', 'remove', 'server', 'remove server']
---

# SQL - `HA REMOVE SERVER`

(Since v2.2) Removes a server from distributed configuration. It returns `true` if the server was found, otherwise `false`.

**Syntax**

```
HA REMOVE SERVER <server-name>
```

- **`<server-name>`** Defines the name of the server to remove.


**Examples**

- Removes the server `europe` from the distributed configuration:

  <pre>
  orientdb> <code class='lang-sql userinput'>HA REMOVE SERVER europe</code>
  </pre>

**Upgrading**

Before v2.2, the list of servers running in HA configuration, was updated with the real situation. This could cause consistency problems in case of split brain network, because the two isolated network partitions could agree with a quorum based on the lower number of servers.

Example: if you have 5 servers with a `writeQuorum:"majority"`, means that if a node is unavailable (crash, network errors, etc.), the quorum is always on base 5, so 4 available nodes are ok. If you've lost also another node, you're still ok, because 3 is still the majority.

With OrientDB v2.2, if 3 nodes of 5 are out, you cannot reach the quorum, so all write operations are forbidden. Why? This is to keep the cluster consistent. 

In facts, if you loose 3 servers of 5, it could happen a split brain network, so you have 2 networks with 2 servers and 3 servers. That's why in v2.2 we keep the servers in the distributed configuration, even if they are offline. Without such mechanism, both network would be able to write and as soon as both networks merge into one (the network problem is fixed), you could have tons of conflicts.

The correct way to remove a server from the configuration is running this command. In this way OrientDB HA will remove it from the list and the base for the quorum would not consider it anymore.


>For more information, see
>- [Distributed Architecture](Distributed-Architecture.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)
