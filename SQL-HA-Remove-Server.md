# SQL - `HA REMOVE SERVER`

Removes a server from distributed configuration. It returns `true` if the server was found, otherwise `false`.

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

>For more information, see
>- [Distributed Architecture](Distributed-Architecture.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)
