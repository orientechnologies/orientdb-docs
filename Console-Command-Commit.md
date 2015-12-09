# Console - COMMIT

Closes a transaction, committing the changes you have made to the database.  Use the [`BEGIN`](Console-Command-Begin.md) command to open a transaction.  If you don't want to save the changes you've made, use the [`ROLLBACK`](Console-Command-Rollback.md) command to revert the database state back to the point where you opened the transaction.

>For more information, see [Transactions](Transactions.md).

**Syntax**

```sql
COMMIT
```

**Example**

- Initiate a transaction, using the [`BEGIN`](Console-Command-Begin.md) command:

  <pre>
  orientdb> <code class="lang-sql userinput">BEGIN</code>

  Transaction 2 is running
  </pre>

- For the sake of example, attempt to open another transaction:

  <pre>
  orientdb> <code class="lang-sql userinput">BEGIN</code>

  Error: an active transaction is currently open (id=2). Commit or rollback 
  before starting a new one.
  </pre>

- Insert data into the class `Account`, using an [`INSERT`](SQL-Insert.md) statement:

  <pre>
  orientdb> <code class="lang-sql userinput">INSERT INTO Account (name) VALUES ('tx test')</code>

  Inserted record 'Account#9:-2{name:tx test} v0' in 0,000000 sec(s).
  </pre>

- Commit the transaction to the database:

  <pre>
  orientdb> <code class="lang-sql userinput">COMMIT</code>

  Transaction 2 has been committed in 4ms
  </pre>

- Display the new content, using a [`SELECT`](SQL-Query.md) query:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM Account WHERE name LIKE 'tx%'</code>

  ---+---------+----------
   # | RID     | name
  ---+---------+----------
   0 | #9:1107 | tx test
  ---+---------+----------

  1 item(s) found. Query executed in 0.041 sec(s).
  </pre>

When a transaction is open, all new records use a temporary Record ID that features negative numbers.  After the commit, they have a permanent Record ID that uses with positive numbers.

>For more information, see
>- [Transactions](Transactions.md)
>- [`BEGIN`](Console-Command-Begin.md)
>- [`ROLLBACK`](Console-Command-Rollback.md)
>- [Console Commands](Console-Commands.md)
