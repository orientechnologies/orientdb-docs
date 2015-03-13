# Console - COMMIT

OrientDB supports [Transactions](Transactions.md). To begin a new transaction use the **begin** command. Once a transaction is begun to make persistent the changes you have to call the [commit](Console-Command-Commit.md) command. To abort the changes call [rollback](Console-Command-Rollback.md) command instead.

## Syntax

```sql
commit
```

## See also

- [Transactions](Transactions.md)
- [Console Command Begin](Console-Command-Begin.md)
- [Console Command Rollback](Console-Command-Rollback.md)
- [Console Commands](Console-Commands.md)

## Example

```
orientdb> begin
Transaction 2 is running

orientdb> begin
Error: an active transaction is currently open (id=2). Commit or rollback before starting a new one.

orientdb> insert into account (name) values ('tx test')

Inserted record 'Account#9:-2{name:tx test} v0' in 0,000000 sec(s).

orientdb> commit
Transaction 2 has been committed in 4ms

orientdb> select from account where name like 'tx%'

---+---------+--------------------
  #| RID     |name
---+---------+--------------------
  0|  #9:1107|tx test
---+---------+--------------------

1 item(s) found. Query executed in 0.041 sec(s).

orientdb>
```

Until the commit all the new records will have a temporary RID with negative numbers.

