# Transaction Propagation

During application development there are situations when a [transaction](Transactions.md) started in one method should be propagated to other method.

Lets suppose we have 2 methods.

```Java
public void method1() {
 database.begin();
 try {
  method2();
  database.commit();
 } catch(Exception e) {
   database.rollback();
 }
}

public void method2() {
  database.begin();
  try {
    database.commit();
  } catch(Exception e) {
    database.rollback();
  }
}
```

As you can see [transaction](Transactions.md) is started in first method and then new one is started in second method.
So how these [transactions](Transactions.md) should interact with each other.
Prior 1.7-rc2 first [transaction](Transactions.md) was rolled back and second was started so were risk that all changes will be lost.

Since 1.7-rc2 we start nested [transaction](Transactions.md) as part of outer transaction.
What does it mean on practice?

Lets consider example above we may have two possible cases here:

First case:

1. begin outer transaction.
2. begin nested transaction.
3. commit nested transaction.
4. commit outer transaction.

When nested transaction is started all changes of outer transaction are visible in nested transaction and
then when nested transaction is committed changes are done in nested transaction are not committed they will be committed at the moment when outer transaction will be committed.

Second case:

1. begin outer transaction.
2. begin nested transaction.
3. rollback nested transaction.
4. commit outer transaction.

When nested transaction is rolled back, changes are done in nested transaction are not rolled back.
But when we commit outer transaction all changes will be rolled back and ORollbackException will be thrown.

So what instances of database should we use to get advantage of [transaction](Transactions.md) propagation feature:

1. The same instance of database should be used between methods.
2. Database pool can be used, in such case all methods which asks for db connection in same
thread will have the same the same database instance.



