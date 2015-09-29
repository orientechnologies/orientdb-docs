# Console - CONFIG

Displays the configuration where the opened database is located (local or remote)

## Syntax

```
CONFIG
```

## Example

```sql
CONFIG

REMOTE SERVER CONFIGURATION:
+------------------------------------+--------------------------------+
| NAME                               | VALUE                          |
+------------------------------------+--------------------------------+
| treemap.lazyUpdates                = 300                            |
| db.cache.enabled                   = false                          |
| file.mmap.forceRetry               = 5                              |
| treemap.optimizeEntryPointsFactor  = 1.0                            |
| storage.keepOpen                   = true                           |
| treemap.loadFactor                 = 0.7                            |
| file.mmap.maxMemory                = 110000000                      |
| network.http.maxLength             = 10000                          |
| storage.cache.size                 = 5000                           |
| treemap.nodePageSize               = 1024                           |
| network.timeout                    = 10000                          |
| file.mmap.forceDelay               = 500                            |
| profiler.enabled                   = false                          |
| network.socketBufferSize           = 32768                          |
| treemap.optimizeThreshold          = 50000                          |
| file.mmap.blockSize                = 300000                         |
| network.retryDelay                 = 500                            |
| network.retry                      = 5                              |
| treemap.entryPoints                = 30                             |
+------------------------------------+--------------------------------+
```

## See also

To change a configuration value use the [CONFIG SET](Console-Command-Config-Set.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
