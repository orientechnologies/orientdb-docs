# Transactions

A transaction comprises a unit of work performed within a database management system (or similar system) against a database, and treated in a coherent and reliable way independent of other transactions. Transactions in a database environment have two main purposes:
 - to provide reliable units of work that allow correct recovery from failures and keep a database consistent even in cases of system failure, when execution stops (completely or partially) and many operations upon a database remain uncompleted, with unclear status
 - to provide isolation between programs accessing a database concurrently. If this isolation is not provided, the program's outcome are possibly erroneous.

A database transaction, by definition, must be [atomic](Transactions.md#Atomicity), [consistent](Transactions.md#Consistency), [isolated](Transactions.md#Isolation) and [durable](Transactions.md#Durability). Database practitioners often refer to these properties of database transactions using the acronym [ACID](Transactions.md#acid-properties).
--- [Wikipedia](http://en.wikipedia.org/wiki/Database_transaction)

OrientDB is an [ACID](Transactions.md#acid-properties) compliant DBMS.

>**NOTE**: OrientDB keeps the transaction on client RAM, so the transaction size is affected by the available RAM (Heap memory) on JVM. For transactions involving many records, consider to split it in multiple transactions.

## ACID properties
### Atomicity
"Atomicity requires that each transaction is 'all or nothing': if one part of the transaction fails, the entire transaction fails, and the database state is left unchanged. An atomic system must guarantee atomicity in each and every situation, including power failures, errors, and crashes. To the outside world, a committed transaction appears (by its effects on the database) to be indivisible ("atomic"), and an aborted transaction does not happen." - [WikiPedia](http://en.wikipedia.org/wiki/ACID)

### Consistency

"The consistency property ensures that any transaction will bring the database from one valid state to another. Any data written to the database must be valid according to all defined rules, including but not limited to constraints, cascades, triggers, and any combination thereof. This does not guarantee correctness of the transaction in all ways the application programmer might have wanted (that is the responsibility of application-level code) but merely that any programming errors do not violate any defined rules." - [WikiPedia](http://en.wikipedia.org/wiki/ACID)

OrientDB uses the MVCC to assure consistency. The difference between the management of MVCC on transactional and not-transactional cases is that with transactional, the exception rollbacks the entire transaction before to be caught by the application.

Look at this example:

|Sequence| Client/Thread 1 | Client/Thread 2 | Version of record X |
|-----|-----|-------|------|
|1| Begin of Transaction |  | |
|2| read(x)  |  | 10 |
|3|  | Begin of Transaction | |
|4|  | read(x) | 10 |
|5|  |  write(x) | 10 |
|6|  |  commit | 10 -> 11 |
|7| write(x)  |  | 10 |
|8| commit |  | 10 -> 11 = Error, in database x already is at 11|

### Isolation

"The isolation property ensures that the concurrent execution of transactions results in a system state that would be obtained if transactions were executed serially, i.e. one after the other. Providing isolation is the main goal of concurrency control. Depending on concurrency control method, the effects of an incomplete transaction might not even be visible to another transaction." - [WikiPedia](http://en.wikipedia.org/wiki/ACID)

OrientDB has different levels of isolation based on settings and configuration:
- `READ COMMITTED`, the default and the only one available with `remote` protocol
- `REPEATABLE READS`, allowed only with `plocal` and `memory` protocols. This mode consumes more memory than `READ COMMITTED`, because any read, query, etc. keep the records in memory to assure the same copy on further access

To change default Isolation Level, use the Java API:

```java
db.begin()
db.getTransaction().setIsolationLevel(OTransaction.ISOLATION_LEVEL.REPEATABLE_READ);
```

Using `remote` access all the commands are executed on the server, so out of transaction scope. Look below for more information.

Look at this examples:

|Sequence| Client/Thread 1 | Client/Thread 2 |
|-----|-----|-------|------|
|1| Begin of Transaction |  |
|2| read(x) |  |
|3|  | Begin of Transaction |
|4|  | read(x) |
|5|  |  write(x) |
|6|  |  commit |
|7| read(x)  |  |
|8| commit |  |

At operation 7 the client 1 continues to read the same version of x read in operation 2.

|Sequence| Client/Thread 1 | Client/Thread 2 |
|-----|-----|-------|------|
|1| Begin of Transaction |  |
|2| read(x) |  |
|3|  | Begin of Transaction |
|4|  | read(y) |
|5|  |  write(y) |
|6|  |  commit |
|7| read(y)  |  |
|8| commit |  |

At operation 7 the client 1 reads the version of y which was written at operation 6 by client 2. This is because it never reads y before.

#### Breaking of ACID properties when using remote protocol and Commands (SQL, Gremlin, JS, etc)

Transactions are client-side only until the commit. This means that if you're using the "remote" protocol the server can't see local changes.

![Transaction in Remote context](http://www.orientdb.org/images/transaction-remote.png)

In this scenario you can have different isolation levels with commands.

### Durability
"Durability means that once a transaction has been committed, it will remain so, even in the event of power loss, crashes, or errors. In a relational database, for instance, once a group of SQL statements execute, the results need to be stored permanently (even if the database crashes immediately thereafter). To defend against power loss, transactions (or their effects) must be recorded in a non-volatile memory." - [WikiPedia](http://en.wikipedia.org/wiki/ACID)

#### Fail-over

An OrientDB instance can fail for several reasons:
- HW problems, such as loss of power or disk error
- SW problems, such as a Operating System crash
- Application problem, such as a bug that crashes your application that is  connected to the Orient engine.

You can use the OrientDB engine directly in the same process of your application. This gives superior performance due to the lack of inter-process communication. In this case, should your application crash (for any reason), the OrientDB Engine also crashes.

If you're using an OrientDB Server connected remotely, if your application crashes the engine continue to work, but any pending transaction owned by the client will be rolled back.

#### Auto-recovery
At start-up the OrientDB Engine checks to if it is restarting from a crash. In this case, the auto-recovery phase starts which rolls back all pending transactions.

OrientDB has different levels of durability based on storage type, configuration and settings.

## Transaction types
### No Transaction

Default mode. Each operation is executed instantly.

Calls to `begin()`,  `commit()` and  `rollback()` have no effect.

### Optimistic Transaction

This mode uses the well known [Multi Version Control System (MVCC)](http://en.wikipedia.org/wiki/Multiversion_concurrency_control) by allowing multiple reads and writes on the same records. The integrity check is made on commit. If the record has been saved by another transaction in the interim, then an OConcurrentModificationException will be thrown. The application can choose either to repeat the transaction or abort it.

>**NOTE**: OrientDB keeps the transaction on client RAM, so the transaction size is affected by the available RAM (Heap) memory on JVM. For transactions involving many records, consider to split it in multiple transactions.

With [Graph API](Graph-Database-Tinkerpop.md#transactions) transaction begins automatically, with Document API is explicit by using the `begin()` method. With Graphs you can change the [consistency level](Graph-Consistency.md).

Example with Document API:

```java
db.open("remote:localhost:7777/petshop");

try{
  db.begin(TXTYPE.OPTIMISTIC);
  ...
  // WRITE HERE YOUR TRANSACTION LOGIC
  ...
  db.commit();
}catch( Exception e ){
  db.rollback();
} finally{
  db.close();
}
```

In Optimistic transaction new records take temporary [RecordID](Concepts.md#recordid)s to avoid to ask to the server a new [RecordID](Concepts.md#recordid) every time. Temporary [RecordID](Concepts.md#recordid)s have Cluster Id -1 and Cluster Position < -1. When a new transaction begun the counter is reset to -1:-2. So if you create 3 new records you'll have:
- -1:-2
- -1:-3
- -1:-4

At commit time, these temporary records [RecordID](Concepts.md#recordid)s will be converted in the final ones.

### Pessimistic Transaction

This mode is not yet supported by the engine.

## Nested transactions and propagation
OrientDB doesn't support nested transaction. If further `begin()` are called after a transaction is already begun, then the current transaction keeps track of call stack to let to the final commit() call to effectively commit the transaction. Look at [Transaction Propagation](Transaction-propagation.md) more information.

## Record IDs

OrientDB uses temporary [RecordID](Concepts.md#recordid)s with transaction as scope that will be transformed to finals once the transactions is successfully committed to the database. This avoid to ask for a free slot every time a client creates a record.

## Tuning

In some situations transactions can improve performance, typically in the client/server scenario. If you use an Optimistic Transaction, the OrientDB engine optimizes the network transfer between the client and server, saving both CPU and bandwidth.

For further information look at [Transaction tuning](Performance-Tuning.md#wise_use_of_transactions) to know more.

## Distributed environment

Transactions can be committed across a distributed architecture. Look at [Distributed Transactions](Distributed-Architecture.md#distributed-transactions) for more information.

