---
search:
   keywords: ['functions', 'transactions', 'auto start transaction', 'isAutoStartTx']
---

# Functions - isAutoStartTx()

This method shows whether the database is configured to auto-start transactions.

## Auto-Starting Transactions

OrientDB can auto-start transactions when a client begins operations on the database.  Using this function you can determine whether this feature is currently active on the database.  To enable or disable transaction auto-start from a function, use the [`setAutoStartTx()`](Functions-Database-setAutoStartTx.md) function.

### Syntax

```
var isEnabled = db.isAutoStartTx()
```

