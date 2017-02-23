# Old `ODatabaseObjectTx` Impelementation

Prior to the release of version 1.0rc9, the Object API was implemented as a class of `com.orientechnologies.orient.db.object.ODatabaseObjectTx`.  OrientDB has deprecated this class since, but if you want to continue to use it, change the package to `com.orientechnologies.orient.object.db`.

|||
|---|---|
| ![](../warning.png) | This implementation and documentation refers to all `ODatabaseObjectXXX` deprecated classes. |

The Orient Object DB works on top of the [Document API](Document-Database.md) and it's able to treat Java objects without the use of pre-processor, byte enhancer or Proxy classes. It uses the simpler way: the Java Reflection. Please consider that the Java reflection in modern Java Virtual Machines is really fast and the discovering of Java meta data is made at first time. Future implementation could use the byte-code enhancement techniques in addition.

>For more information, see [Binding](Object-2-Record-Java-Binding.md).

Quick example of usage:

```java
// OPEN THE DATABASE
ODatabaseObjectTx db = new ODatabaseObjectTx(
   "remote:localhost/petshop")
   .open("admin", "admin_passwd");

db.getEntityManager().registerEntityClasses("foo.domain");

// CREATE A NEW ACCOUNT OBJECT AND FILL IT
Account account = new Account()
account.setName( "Luke" );
account.setSurname( "Skywalker" );

City rome = new City("Rome", new Country("Italy"));
account.getAddresses()
   .add(new Address("Residence", rome, "Piazza Navona, 1"));

db.save( account );
```

## Connection Pool

One of most common use case is to reuse the database avoiding to create it every time. It's also the typical scenario of the Web applications.

```java
// OPEN THE DATABASE
ODatabaseObjectTx db= ODatabaseObjectPool.global().acquire("remote:localhost/petshop", "admin", "admin");

...

db.close();
```

The `close()` method doesn't close the database but release it to the owner pool. It could be reused in the future.



## Inheritance

Starting from the release 0.9.19 OrientDB supports the [Inheritance](../Inheritance.md). Using the Object API the inheritance of Documents fully matches the Java inheritance.

For instance,

```java
public class Account {
   private String name;
}

public class Company extends Account {
   private int employees;
}
```

When you save a `Company` object, OrientDB saves the object as a unique document in the cluster specified for the `Company` class.  When you search between all `Account` instances, such as with

<pre>
orientdb> <code class="userinput lang-sql">SELECT FROM Account</code>
</pre>

the search finds all `Account` and `Company` documents that satisfy the query.
