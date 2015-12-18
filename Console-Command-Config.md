# Console - `CONFIG`

Displays the configuration information on the current database, as well as whether it is local or remote.

**Syntax**

```sql
CONFIG
```

**Examples**

- Display the configuration of the current database:

  <pre>
  orientdb> <code class="userinput lang-sql">CONFIG</code>

  REMOTE SERVER CONFIGURATION:
  +------------------------------------+--------------------------------+
  | NAME                               | VALUE                          |
  +------------------------------------+--------------------------------+
  | treemap.lazyUpdates                | 300                            |
  | db.cache.enabled                   | false                          |
  | file.mmap.forceRetry               | 5                              |
  | treemap.optimizeEntryPointsFactor  | 1.0                            |
  | storage.keepOpen                   | true                           |
  | treemap.loadFactor                 | 0.7                            |
  | file.mmap.maxMemory                | 110000000                      |
  | network.http.maxLength             | 10000                          |
  | storage.cache.size                 | 5000                           |
  | treemap.nodePageSize               | 1024                           |
  | ...                                | ...                            |
  | treemap.entryPoints                | 30                             |
  +------------------------------------+--------------------------------+
  </pre>

>You can change configuration variables displayed here using the [`CONFIG SET`](Console-Command-Config-Set.md) command.  To display the value set to one configuration variable, use the [`CONFIG GET`](Console-Command-Config-Get.md) command.
>
>For more information on other commands, see [Console Commands](Console-Commands.md).
