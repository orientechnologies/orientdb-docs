# Release 2.1.x
____


##What's new?
### Live Query

OrientDB 2.1 includes the first experimental version of LiveQuery. See details  [here](https://github.com/orientechnologies/orientdb-docs/blob/master/Live-Query.md).

## Migration from 2.0.x to 2.1.x

Databases created with release 2.0.x are compatible with 2.1, so you don't have to export/import the database. 

### Difference function

In 2.0.x difference() function had inconsistent behavior: it actually worked as a symmetric difference (see [4366](https://github.com/orientechnologies/orientdb/issues/4366), [3969](https://github.com/orientechnologies/orientdb/issues/3969))
In 2.1 it was refactored to perform normal difference ([https://proofwiki.org/wiki/Definition:Set_Difference](https://proofwiki.org/wiki/Definition:Set_Difference)) and another function was created for symmetric difference (called "symmetricDifference()").

If for some reason you application relied on the (wrong) behavior of difference() function, please change your queries to invoke symmetricDifference() instead.

### Strict SQL parser

V 2.1 introduces a new implementation of the new SQL parser. This implementation is more strict, so some queries that were allowed in 2.0.x could not work now.

For backward compatibility, you can disable the new parser from Studio -> DB -> Configuration -> remove the flag from strictSql (bottom right of the page).

![strictSQL](images/strictSQL.png)

Or via console by executing this command, just once:

```sql
ALTER DATABASE custom strictSql=false
```

Important improvements of the new parser are:
* full support for named (:param) and unnamed (?) input parameters: now you can use input parameters almost everywhere in a query: in subqueries, function parameters, between square brackets, as a query target
* better management of blank spaces and newline characters: the old parser was very sensitive to presence or absence of blank spaces (especially in particular points, eg. before and after square brackets), now the problem is completely fixed
* strict validation: the old parser in some cases failed to detect invalid queries (eg. a macroscopic example was a query with two WHERE conditions, like SELECT FORM Foo WHERE a = 2 WHERE a = 3), now all these problems are completely fixed

Writing the new parser was a good opportunity to validate our query language. We discovered some ambiguities and we had to remove them. Here is a short list of these problems and how to manage them with the new parser:
* ```-``` as a valid character for identifiers (property and class names): in the old implementation you could define a property name like "simple-name" and do ```SELECT simple-name FROM Foo```. This is not allowed anymore, because ```-``` character is used for arithmetic operations (subtract). To use names with  ```-``` character, use backticks. Example:  ```SELECT `simple-name` FROM Foo```
* reserved keywords as identifiers: words like ```select```, ```from```, ```where```... could be used as property or class name, eg. this query was valid ```SELECT FROM FROM FROM```. In v 2.1 all the reserved keywords have to be quoted with a backtick to be used as valid identifiers: ```SELECT `FROM` FROM `FROM` ```

### Object database
Before 2.1 entity class cache was static, so you could not manage multiple OObjectDatabase connections in the same VM. In 2.1 registerEntityClass() works at storage level, so you can open multiple OObjectDatabase connections in the same VM.

IMPORTANT: in 2.1 if you close and re-open the storage, you have to re-register your POJO classes.

### Distributed architecture
Starting from release 2.1.6 it's not possible to hot upgrade a distributed architecture node by node, because the usage of the last recent version of Hazelcast that breaks such network compatibility. If you're upgrading a distributed architecture you should power off the entire cluster and restart it with the new release.

### API changes

#### ODatabaseDocumentTx.activateOnCurrentThread()
If by upgading to v2.1 you see errors of kind "Database instance is not set in current thread...", this means that you used the same ODatabase instance across multiple threads. This was always forbidden, but some users did it with unpredictable results and random errors. For this reason in v2.1 OrientDB always checks that the ODatabase instance was bound to the current thread.

We introduced a new API to allow moving a ODatabase instance across threads. Before to use a ODatabase instance call the method `ODatabaseDocumentTx.activateOnCurrentThread()` and the ODatabase instance will be bound to the current thread. Example:

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal/temp/mydb").open("admin", "admin");
new Thread(){
  public void run() {
    db.activateOnCurrentThread(); // <---- BINDS THE DATABASE ON CURRENT THREAD
    db.command(new OCommandSQL("select from MyProject where thisSummerIsVeryHot = true")).execute();
  }
}.start();
```
