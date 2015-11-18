# Console - BEGIN

OrientDB supports [Transactions](Transactions.md). To begin a new transaction use the `BEGIN` command. Once a transaction is begun to make persistent the changes you have to call the [COMMIT](Console-Command-Commit.md) command. To abort the changes call [ROLLBACK](Console-Command-Rollback.md) command instead.

## Syntax

```sql
BEGIN
```

## See also

- [Transactions](Transactions.md)
- [Console Command COMMIT](Console-Command-Commit.md)
- [Console Command ROLLBACK](Console-Command-Rollback.md)
- [Console Commands](Console-Commands.md)

## Example

```sql
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
```

Until the commit all the new records will have a temporary RID with negative numbers.

