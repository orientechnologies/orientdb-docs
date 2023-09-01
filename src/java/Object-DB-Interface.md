
# Object Interface

In OrientDB the Object API operates on a [Document Data](Document-Database.md).  It functions as an Object Database, directly managing objects in your Java application.  In order to utilize this API, you need to initialize the object interface from within your Java application.

## Initializing Object Interfaces

The Object API interface is an instance of the Database Object type.  For instance,


**Opening Databases**

  ```java
  // OPEN DATABASE
  OrientDBObject orientDB = new OrientDBObject("embedded:/data");
  ODatabaseObject db = orientDB.open("petshop","admin","admin_passwd");
  ```

### Closing Databases

When you're finished with the object interface, you need to close the database to free up the resources it holds.  You can do this using the `close()` method.  For instance,

```java
db.close();
```

### Using Connection Pools

Common use-case when developing applications for OrientDB, especially in the case of web apps, is to utilize a connection pool.  This allows you to reuse a given database connection, rather than creating a new one every time it's needed.

To open a database from the pool, use the `ODatabaseObjectPool` object:

```java
// OPEN DATABASE
ODatabaseObjectPool pool = new ODatabaseObjectPool("remote:localhost/petshop",
            "admin", "admin",OrientDBConfig.defaultConfig());
ODatabaseObject db = pool.acquire();

// REGISTER THE CLASS ONLY ONCE AFTER DB IS OPEN/CREATED
db.getEntityManager().registerEntityClass("org.petshop.domain");

try {
   //...
} finally {
   db.close();
}

//...
pool.close();
```

In this case the `close()` method doesn't close the database.  Rather it releases it into the owner pool, so that it can be reused later.



## Using Interfaces

Once you have initialized the object interface, you can begin to use it in your application.  The Object API uses Java Reflection to register classes and the [Javassist](http://www.jboss.org/javassist) tool to manage the object-to-document conversion.  With modern Java virtual machines, Java Reflection is very fast and only needs to perform meta-data discovery once.

```java
// OPEN DATABASE
OrientDBObject orientDB = new OrientDBObject("remote:localhost");
ODatabaseObject db = orientDB.open("petshop","admin","admin_passwd");

// REGISTER CLASS ONLY ONCE AFTER DB IS OPENED/CREATED
db.getEntityManager().registerEntityClass("org.petshop.domain");

// CREATE NEW PROXIED OBJECT AND FILL IT
Account account = db.newInstance(Account.class);
account.setName("Tully");
account.setSurname("Cicero");

City rome = db.newInstance(City.class, "Rome",
   db.newInstance(Country.class, "Italy"));
account.getAddress().add(
   new Address("Residence", rome, "Piazza Navona, 1");

// SAVE
db.save(account);

// CREATE NEW PROXIED OBJECT AND FILL IT
Account account = new Account();
account.setName("Alessandro");
account.setSurname("Manzoni");

City milan = new City("Milan",
   new Country("Italy"));
account.getAddress()
   .add(new Address("Residence", milan,
   "Piazza Manzoni, 1"));

// SAVE ACCOUNT: ORIENTDB SERIALIZES OBJECT & GIVES PROXIED INSTANCE
account = db.save(account);
```

### Multi-threading

When working with multi-threaded applications, bear in mind that the `ODatabaseObject` object interface that you use initialize your database instance is not thread safe.  For this reason, when working with multiple threads always initialize a separate `ODatabaseObject` instance for each thread.


### Inheritance

Beginning with version 0.9.19, OrientDB supports inheritance.  When using the Object API, document inheritance fully matches Java inheritance.  Additionally, when you register a new class, OrientDB generates the correct inheritance schema in the event that it doesn't exist already.

```java
// SUPERCLASS
public class Account{
   private String name;
   // getters and setters
}

// SUBCLASS
public class Company extends Account {
   private int employees;
   // getters and setters
}
```

Whenever you save a `Company` object in this example, OrientDB saves the object as a unique document in the cluster specified for the `Company` class.  When you search all `Account` instances, you'll also match instances of `Company`.

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM Account</code>
</pre>
