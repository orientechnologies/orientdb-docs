# Console - ROLLBACK

OrientDB supports [Transactions](Transactions.md). Once a transaction is [BEGIN](Console-Command-Begin.md) you can abort changes in transactions by using the **ROLLBACK** command.

## Syntax

```sql
ROLLBACK
```
## See also

- [Transactions](Transactions.md)
- [Console Command COMMIT](Console-Command-Commit.md)
- [Console Command ROLLBACK](Console-Command-Rollback.md)
- [Console Commands](Console-Commands.md)

## Example

```
orientdb> BEGIN
Transaction 1 is running

orientdb> BEGIN
Error: an active transaction is currently open (id=1). Commit or rollback before starting a new one.

orientdb> INSERT INTO account (name) VALUES ('tx test')

Inserted record 'Account#9:-2{name:tx test} v0' in 0,004000 sec(s).

orientdb> SELECT FROM account WHERE name LIKE 'tx%'

---+---------+--------------------
  #| RID     |name
---+---------+--------------------
  0|    #9:-2|tx test
---+---------+--------------------

1 item(s) found. Query executed in 0.076 sec(s).

orientdb> ROLLBACK
Transaction 1 has been rollbacked in 4ms

orientdb> SELECT FROM account WHERE name LIKE 'tx%'

0 item(s) found. Query executed in 0.037 sec(s).
```
