
# Object API
> groupId: **com.orientechnologies**  artifactId: **orientdb-object**

The Object Database in OrientDB operates on top of the [Document API](Document-Database.md).  The Object API uses Java Reflection to register the classes and the [Javassist](http://www.jboss.org/javassist) tool to manage the object-to-document conversion.

In modern Java virtual machines, Java Reflection works really fast and metadata discovery is only done on the first run.  Future implementations may also include byte-code enhancement techniques.

- [**Object Interface**](Object-DB-Interface.md)


## Understanding the Object API

When using the Object API, you bind objects in your application to `ODocument` objects in OrientDB.  These proxied objects transparently replicate changes into the database.  

It also allows for lazy loading of fields, ensuring that they won't be loaded from the document until the first access.  To do this, the object MUST implement [getters and setters](http://en.wikipedia.org/wiki/Mutator_method), given that the Object API binds the Javassist Proxy to them.  In case of object load that edits an update, only loaded fields are lost, non-loaded fields remain untouched.

The database instance has an API to generate new objects already proxied.  When a non-proxied instance is passed to it, it serialized the instance, wrapping it around a proxied instance.

```java
// OPEN DATABASE
OrientDBObject orientDB = new OrientDBObject("remote:localhost");
ODatabaseObject db = orientDB.open("petshop","admin", "admin_passwd");

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


