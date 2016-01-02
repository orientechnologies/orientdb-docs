# Console - `ROLLBACK`

Aborts a transaction, rolling the database back to its save point.

**Syntax**

```sql
BEGIN
```

>For more information on transactions, see [Transactions](Transactions.md).  To initiate a transaction, use the [`BEGIN`](Console-Command-Begin.md) command.  To save changes, see [`COMMIT`](Console-Command-Commit.md) command.


**Example**

- Initiate a new transaction:

  <pre>
  orientdb> <code class='lang-sql userinput'>BEGIN</code>

  Transaction 1 is running
  </pre>

- Attempt to start a new transaction, while another is open:

  <pre>
  orientdb> <code class='lang-sql userinput'>BEGIN</code>

  Error: an active transaction is currently open (id=1). Commit or rollback before starting a new one.
  </pre>

- Make changes to the database:

  <pre>
  orientdb> <code class='lang-sql userinput'>INSERT INTO Account (name) VALUES ('tx test')</code>

  Inserted record 'Account#9:-2{name:tx test} v0' in 0,004000 sec(s).
  </pre>

- View changes in database:

  <pre>
  orientdb> <code class='lang-sql userinput'>SELECT FROM Account WHERE name LIKE 'tx%'</code>

  ---+-------+--------------------
   # | RID   | name
  ---+-------+--------------------
   0 | #9:-2 | tx test
  ---+-------+--------------------
  1 item(s) found. Query executed in 0.076 sec(s).
  </pre>

- Abort the transaction:

  <pre>
  orientdb> <code class="lang-sql userinput">ROLLBACK</code>

  Transaction 1 has been rollbacked in 4ms
  </pre>

- View rolled back database:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM Account WHERE name LIKE 'tx%'</code>

  0 item(s) found. Query executed in 0.037 sec(s).
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).