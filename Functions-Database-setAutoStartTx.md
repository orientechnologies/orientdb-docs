---
search:
   keywords: ['functions', 'transactions', 'auto start transaction', 'setAutoStartTx']
---

# Functions - setAutoStartTx()

This method enables or disables transaction auto-start.


## Auto-Starting Transactions

OrientDB can auto-start transactions when a client begins operations on the database.  Using this method you can enable or disable transaction auto-start.  To check its current state, use the [`isAutoStartTx()`](Functions-Database-isAutoStartTx.md) function

### Syntax

```
db.setAutoStartTx(<state>)
```

- **`<state>`** Defines whether you want to enable transaction auto-start.

