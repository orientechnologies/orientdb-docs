# Console - COMMIT

OrientDB supports [Transactions](Transactions.md). To begin a new transaction use the **begin** command. Once a transaction is begun to make persistent the changes you have to call the [commit](Console-Command-Commit.md) command. To abort the changes call [rollback](Console-Command-Rollback.md) command instead.

## Syntax

```sql
COMMIT
```

## See also

- [Transactions](Transactions.md)
- [Console Command BEGIN](Console-Command-Begin.md)
- [Console Command ROLLBACK](Console-Command-Rollback.md)
- [Console Commands](Console-Commands.md)

## Example

```
orientdb> BEGIN
Transaction 2 is running

orientdb> BEGIN
Error: an active transaction is currently open (id=2). Commit or rollback before starting a new one.

orientdb> INSERT INTO account (name) VALUES ('tx test')

Inserted record 'Account#9:-2{name:tx test} v0' in 0,000000 sec(s).

orientdb> COMMIT
Transaction 2 has been committed in 4ms

orientdb> SELECT FROM account WHERE name LIKE 'tx%'

---+---------+--------------------
  #| RID     |name
---+---------+--------------------
  0|  #9:1107|tx test
---+---------+--------------------

1 item(s) found. Query executed in 0.041 sec(s).
```

Until the commit all the new records will have a temporary RID with negative numbers.

