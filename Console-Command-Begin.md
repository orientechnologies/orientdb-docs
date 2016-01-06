<!-- proofread 2015-01-06 SAM -->

# Console - `BEGIN`

Initiates a transaction.  When a transaction is open, any commands you execute on the database remain temporary. In the event that you are satisfied with the changes, you can call the [`COMMIT`](Console-Command-Commit.md) command to commit them to the database.  Otherwise, you can call the [`ROLLBACK`](Console-Command-Rollback.md) command, to roll the changes back to the point where you called [`BEGIN`](Console-Command-Begin.md).

**Syntax:**

```sql
BEGIN
```

**Examples**

- Begin a transaction:

  <pre>
  orientdb> <code class="lang-sql userinput">BEGIN</code>

  Transaction 1 is running
  </pre>

- Attempting to begin a transaction when one is already open:

  <pre>
  orinetdb> <code class='lang-sql userinput'>BEGIN</code>

  Error: an active transaction is currently open (id=1).  Commit or rollback 
  before starting a new one.
  </pre>

- Making changes when a transaction is open:

  <pre>
  orientdb> <code class="lang-sql userinput">INSERT INTO Account (name) VALUES ('tx test')</code

  Inserted record 'Account#9:-2{name:tx test} v0' in 0,004000 sec(s).

  orientdb> <code class="lang-sql userinput">SELECT FROM Account WHERE name LIKE 'tx%'</code>
   
   ---+-------+----------
    # | RID   | name	
   ---+-------+----------
    0 | #9:-2 | tx test
   ---+-------+----------
   </pre>

When a transaction is open, new records all have temporary Record ID's, which are given negative values, (for instance, like the `#9:-2` shown above).  These remain in effect until you run [`COMMIT`](Console-Command-Commit.md)

>For more information on Transactions, see

>- [Transactions](Transactions.md)
>- [Console Command COMMIT](Console-Command-Commit.md)
>- [Console Command ROLLBACK](Console-Command-Rollback.md)
>- [Console Commands](Console-Commands.md)
