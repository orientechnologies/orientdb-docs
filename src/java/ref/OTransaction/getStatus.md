
# OTransaction - getStatus()

Retrieves the status of the transaction.

## Transaction Status

Transactions have status, indicating where they are in the process.  That is, started, committing, rolling back, and so on.  Using this method, you can retrieve the current status of the transaction. 

### Syntax

```
OTransaction.TXSTATUS OTransaction().getStatus()
```

#### Return Type

This method returns an `OTransaction.TXSTATUS` object, which is one of the following:

| Enum Constants | Description |
|---|---|
| `BEGUN` | The transaction has started |
| `COMMITTING` | The transaction is being committed to the database |
| `COMPLETED` | The transaction is committed |
| `INVALID` | The transaction has encountered an error |
| `ROLLBACKING` | The transaction is being rolled back |
| `ROLLED_BACK` | The transaction has been reverted |



