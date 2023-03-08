---
search:
   keywords: ['java', 'otransaction']
---

# OTransaction

This method provides an interface for working with transactions.

## Using Transactions

In order to operate on the transaction within your application, you need to import it into your application.

```java
import com.orientechnologies.orient.core.tx.OTransaction;
```

### Methods

| Method | Return Type | Description |
|---|---|---|
| [**`amountOfNestedTxs()`**](OTransaction/amountOfNestedTxs.md) | `int` | Returns the number of transactions attached to this instance |
| [**`begin()`**](OTransaction/begin.md) | `void` | Initiates the transaction |
| [**`close()`**](OTransaction/close.md) | `void` | Closes the transaction |
| [**`commit()`**](OTransaction/commit.md) | `void` | Commits the transaction |
| [**`getDatabase()`**](OTransaction/getDatabase.md) | [`ODatabaseDocument`](ODatabaseDocument.md) | Retrieves the database |
| [**`getEntryCount()`**](OTransaction/getEntryCount.md) | `int` | Retrieves the number of entries in the transaction |
| [**`getInvolvedIndexes()`**](OTransaction/getInvolvedIndexes.md) | `List<String>` | Retrieves indexes used in the transaction |
| [**`getIsolationLevel()`**](OTransaction/getIsolationLevel.md) | `OTransaction.ISOLATION_LEVEL` | Retrieves the transaction Isolation Level |
| [**`getNewRecordEntriesByClass()`**](OTransaction/getNewRecordEntriesByClass.md) | [`List<ORecordOperation>`](ORecordOperation.md) | Retrieves a list of record operations by [`OClass`](OClass.md) from the transaction |
| [**`getNewRecordEntriesByCluster()`**](OTransaction/getNewRecordEntriesByCluster.md) | [`List<ORecordOperation>`](ORecordOperation.md) | Retrieves a list of record operation by [`OCluster`](OCluster.md) from the transaction |
| [**`getRecordEntry()`**](OTransaction/getRecordEntry.md) | [`ORecordOperation`](ORecordOperation.md) | Retrieves a record operation from the transaction |
| [**`getRecordOperations()`**](OTransaction/getRecordOperations.md) | [`Iterable<? extends ORecordOperation>`](ORecordOperation.md) | Retrieves record operations from the transaction |
| [**`getStatus()`**](OTransaction/getStatus.md) | `OTransaction.TXSTATUS` | Retrieves the transaction status |
| [**`hasRecordCreation()`**](OTransaction/hasRecordCreation.md) | `boolean` | Indicates whether any records were created in the transaction |
| [**`rollback()`**](OTransaction/rollback.md) | `void` | Reverts changes from the transaction |
| [**`setIsolationLevel()`**](OTransaction/setIsolationLevel.md) | `OTransaction` | Sets the transaction Isolation Level |

