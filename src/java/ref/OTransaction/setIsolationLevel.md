
# OTransaction - setIsolationLevel()

Retrieves the isolation level of the transaction.

## Isolation Levels in OrientDB

OrientDB supports the use of different levels of isolation based on settings and configuration.  Using this method you can set the isolation level for the transaction.

### Syntax

```
OTransaction OTransaction().setIsolationLevel(OTransaction.ISOLATION_LEVEL level)
```

| Argument | Type | Description |
|---|---|---|
| **`level`** | `OTransaction.ISOLATION_LEVEL` | Defines the isolation level |

The given Isolation Level belongs to one of the enumerated constants: `READ_COMMITTED` or `REPEATABLE_READ`.


#### Return Value

This method returns the [`OTransaction`](../OTransaction.md) instance.




