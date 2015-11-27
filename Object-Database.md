# Object API

|![](images/warning.png)|Object API allows to work with POJOs that bind [OrientDB documents](Document-Database.md). This API is not able work on top of [Graph-API](Graph-Database-Tinkerpop.md). If you are interested on using a Object-Graph mapping framework, look at the available ones that work on top of [Graph-API](Graph-Database-Tinkerpop.md) layer: [Object-Graph Mapping](http://wiki.syncleus.com/index.php/Ferma:Comparing_the_Alternatives).
|---|----|

# Requirements

To use the Object APi include the following jars in your classpath:
```java
orientdb-core-*.jar
orientdb-object-*.jar
```

If you're using the Object Database interface connected to a remote server (not local/embedded mode) include also:
```java
orientdb-client-*.jar
orientdb-enterprise-*.jar
```

# Introduction

The OrientDB **Object Interface** works on top of the [Document-Database](Document-Database.md) and works like an Object Database: manages Java objects directly. It uses the Java Reflection to register the classes  and [Javassist tool](http://www.jboss.org/javassist) to manage the Object-to-Document conversion. Please consider that the Java Reflection in modern Java Virtual Machines is really fast and the discovering of Java meta data is made only at first time.

Future implementation could use also the byte-code enhancement techniques in addition.

The proxied objects have a ODocument bounded to them and transparently replicate object modifications. It also allows lazy loading of the fields: they won't be loaded from the document until the first access. To do so the object MUST implement [getters and setters](http://en.wikipedia.org/wiki/Mutator_method) since the [Javassist Proxy](http://www.jboss.org/javassist) is bounded to them.
In case of object load, edit an update all non loaded fields won't be lost.

The database instance has an API to generate new objects already proxied, in case a non-proxied instance is passed it will be serialized, wrapped around a proxied instance and returned.

Read more about the [Binding between Java Objects and Records](Object-2-Record-Java-Binding.md).

Quick example of usage:
```java
// OPEN THE DATABASE
OObjectDatabaseTx db = new OObjectDatabaseTx ("remote:localhost/petshop").open("admin", "admin");

// REGISTER THE CLASS ONLY ONCE AFTER THE DB IS OPEN/CREATED
db.getEntityManager().registerEntityClasses("foo.domain");

// CREATE A NEW PROXIED OBJECT AND FILL IT
Account account = db.newInstance(Account.class);
account.setName( "Luke" );
account.setSurname( "Skywalker" );

City rome =  db.newInstance(City.class,"Rome",  db.newInstance(Country.class,"Italy"));
account.getAddresses().add(new Address("Residence", rome, "Piazza Navona, 1"));

db.save( account );

// CREATE A NEW OBJECT AND FILL IT
Account account = new Account();
account.setName( "Luke" );
account.setSurname( "Skywalker" );

City rome = new City("Rome", new Country("Italy"));
account.getAddresses().add(new Address("Residence", rome, "Piazza Navona, 1"));

// SAVE THE ACCOUNT: THE DATABASE WILL SERIALIZE THE OBJECT AND GIVE THE PROXIED INSTANCE
account = db.save( account );
```

## Connection Pool

One of most common use case is to reuse the database avoiding to create it every time. It's also the typical scenario of the Web applications.
```java
// OPEN THE DATABASE
OObjectDatabaseTx db= OObjectDatabasePool.global().acquire("remote:localhost/petshop", "admin", "admin");

// REGISTER THE CLASS ONLY ONCE AFTER THE DB IS OPEN/CREATED
db.getEntityManager().registerEntityClass("org.petshop.domain");

try {
  ...
} finally {
  db.close();
}
```

The close() method doesn't close the database but release it to the owner pool. It could be reused in the future.

## Database URL

In the example above a database of type Database Object Transactional has been created using the storage: remote:localhost/petshop. This address is a [URL](http://it.wikipedia.org/wiki/Uniform_Resource_Locator). To know more about database and storage types go to [Database URL](Concepts.md#database_url).

In this case the storage resides in the same computer of the client, but we're using the **remote** storage type. For this reason we need a OrientDB Server instance up and running. If we would open the database directly bypassing the server we had to use the **local** storage type such as "plocal:/usr/local/database/petshop/petshop" where, in this case, the storage was located in the /usr/local/database/petshop folder on the local file system.

## Multi-threading

The OObjectDatabaseTx class is non thread-safe. For this reason use different OObjectDatabaseTx instances by multiple threads. They will share local cache once transactions are committed.

## Inheritance

Starting from the release 0.9.19 OrientDB supports the [Inheritance](Inheritance.md). Using the ObjectDatabase the inheritance of Documents fully matches the Java inheritance.

When registering a new class Orient will also generate the correct inheritance schema if not already generated.

Example:
```java
public class Account {
  private String name;
// getters and setters
}

public class Company extends Account {
  private int employees;
// getters and setters
}
```

When you save a Company object, OrientDB will save the object as unique Document in the cluster specified for Company class. When you search between all the Account instances with:
```java
SELECT FROM account
```

The search will find all the Account and Company documents that satisfy the query.

# Use the database

Before to use a database you need to open or create it:
```java
// CREATE AN IN MEMORY DATABASE
OObjectDatabaseTx db1 = new OObjectDatabaseTx("memory:petshop").create();

// OPEN A REMOTE DATABASE
OObjectDatabaseTx db2 = new OObjectDatabaseTx("remote:localhost/petshop").open("admin", "admin");
```

The database instance will share the connection versus the storage. if it's a local storage, then all the database instances will be synchronized on it. If it's a remote storage then the network connection will be shared among all the database instances.

To get the reference to the current user use:
```java
OUser user = db.getUser();
```

Once finished remember to close the database to free precious resources.
```java
db.close();
```

# Working with POJO

Please read the [POJO binding guide](Object-2-Record-Java-Binding.md) containing all the information about the management of POJO.

## Work in schema-less mode

The Object Database can be used totally in schema-less mode as long as the [POJO binding guide](Object-2-Record-Java-Binding.md) requirements are followed. Schema less means that the class must be created but even without properties. Take a look to this example:

```java
OObjectDatabaseTx db = new OObjectDatabaseTx("remote:localhost/petshop").open("admin", "admin");
db.getEntityManager().registerEntityClass(Person.class);

Person p = db.newInstance(Person.class);
p.setName( "Luca" );
p.setSurname( "Garulli" );
p.setCity( new City( "Rome", "Italy" ) );

db.save( p );
db.close();
```

This is the very first example. While the code it's pretty clear and easy to understand please note that we didn't declared "Person" structure before now. However Orient has been able to recognize the new object and save it in persistent way.

## Work in schema-full mode

In the schema-full mode you need to declare the classes you're using. Each class contains one or multiple properties. This mode is similar to the classic Relational DBMS approach where you need to create tables before storing records. To work in schema-full mode take a look at the [Schema APIs](Java-Schema-Api.md) page.

## Create a new object

The best practice to create a Java object is to use the OObjectDatabaseTx.newInstance() API:

```java
public class Person {
  private String name;
  private String surname;

  public Person(){
  }

  public Person(String name){
   this.name = name;
  }

  public Person(String name, String surname){
   this.name = name;
   this.surname = surname;
  }
// getters and setters
}

OObjectDatabaseTx db = new OObjectDatabaseTx("remote:localhost/petshop").open("admin", "admin");
db.getEntityManager().registerEntityClass(Person.class);

// CREATES A NEW PERSON FROM THE EMPTY CONSTRUCTOR
Person person = db.newInstance(Person.class);
animal.setName( "Antoni" );
animal.setSurname( "Gaudi" );
db.save( person );

// CREATES A NEW PERSON FROM A PARAMETRIZED CONSTRUCTOR
Person person = db.newInstance(Person.class,  "Antoni");
animal.setSurname( "Gaudi" );
db.save( person );

// CREATES A NEW PERSON FROM A PARAMETRIZED CONSTRUCTOR
Person person = db.newInstance(Person.class,"Antoni","Gaudi");
db.save( person );
```

However any Java object can be saved by calling the db.save() method, if not created with the database API will be serialized and saved. In this case the user have to assign the result of the db.save() method in order to get the proxied instance, if not the database will always treat the object as a new one.
Example:
```java
// REGISTER THE CLASS ONLY ONCE AFTER THE DB IS OPEN/CREATED
db.getEntityManager().registerEntityClass(Animal.class);

Animal animal = new Animal();
animal.setName( "Gaudi" );
animal.setLocation( "Madrid" );
animal = db.save( animal );
```

Note that the behaviour depends by the transaction begun if any. See [Transactions](Transactions.md).

## Browse all the records in a cluster

```java
for (Object o : database.browseCluster("CityCars")) {
  System.out.println( ((Car) o).getModel() );
```

## Browse all the records of a class

```java
for (Animal animal : database.browseClass(Animal.class)) {
  System.out.println( animal.getName() );
```

## Count records of a class

```java
long cars = database.countClass("Car");
```

## Count records of a cluster

```java
long cityCars = database.countCluster("CityCar");
```

## Update an object

Any proxied object can be updated using the Java language and then calling the db.save() method to synchronize the changes to the repository. Behaviour depends by the transaction begun if any. See [Transactions](Transactions.md).

```java
animal.setLocation( "Nairobi" );
db.save( animal );
```

Orient will update only the fields really changed.

Example of how to update the price of all the animals by 5% more:

```java
for (Animal animal : database.browseClass(Animal.class)) {
  animal.setPrice(animal.getPrice() * 105 / 100);
  database.save(animal);
}
```

If the db.save() method is called with a non-proxied object the database will create a new document, even if said object were already saved

## Delete an object

To delete an object call the db.delete() method on a proxied object. If called on a non-proxied object the database won't do anything. Behaviour also depends by the transaction begun if any. See [Transactions](Transactions.md).

```java
db.delete( animal );
```

Example of deletion of all the objects of class "Animal".

```java
for (Animal animal : database.browseClass(Animal.class))
  database.delete(animal);
```

### Cascade deleting

Object Database uses JPA annotations to manage cascade deleting. It can be done expliciting (orphanRemoval = true) or using the CascadeType.
The first mode works only with @OneToOne and @OneToMany annotations, the CascadeType works also with @ManyToMany annotation.

Example:
```java
public class JavaCascadeDeleteTestClass {
  ...

  @OneToOne(orphanRemoval = true)
  private JavaSimpleTestClass  simpleClass;

  @ManyToMany(cascade = { CascadeType.REMOVE })
  private Map<String, Child>   children	= new HashMap<String, Child>();

  @OneToMany(orphanRemoval = true)
  private List<Child>          list = new ArrayList<Child>();

  @OneToMany(orphanRemoval = true)
  private Set<Child> set = new HashSet<Child>();
  ...

  // GETTERS AND SETTERS
}
```

so calling

```java
database.delete(testClass);
```

or

```java
for (JavaCascadeDeleteTestClass testClass : database.browseClass(JavaCascadeDeleteTestClass.class))
  database.delete(testClass);
```

will also delete JavaSimpleTestClass instances contained in "simpleClass" field and all the other documents contained in "children","list" and "test"

## Attaching and Detaching

Since version 1.1.0 the Object Database provides attach(Object) and detach(Object) methods to manually manage object to document data transfer.

### Attach

With the attach method all data contained in the object will be copied in the associated document, overwriting all existing informations.

```java
Animal animal = database.newInstance(Animal.class);
animal.name = "Gaudi" ;
animal.location = "Madrid";
database.attach(animal);
database.save(animal);
```

in this way all changes done within the object without using setters will
be copied to the document.

There's also an attachAndSave(Object) methods that after attaching data saves the object.

```java
Animal animal = database.newInstance(Animal.class);
animal.name = "Gaudi" ;
animal.location = "Madrid";
database.attachAndSave(animal);
```

This will do the same as the example before

### Detach

With the detach method all data contained in the document will be copied in the associated object, overwriting all existing informations. The detach(Object) method returns a proxied object, if there's a need to get a non proxied detached instance the detach(Object,boolean) can be used.

```java
Animal animal = database.load(rid);
database.detach(animal);
```

this will copy all the loaded document information in the object, without needing to call all getters. This methods returns a proxied instance

```java
Animal animal = database.load(rid);
animal = database.detach(animal,true);
```

this example does the same as before but in this case the detach will return a non proxied instance.

Since version 1.2 there's also the detachAll(Object, boolean) method that detaches recursively the entire object tree. This may throw a StackOverflowError with big trees. To avoid it increase the stack size with -Xss java option.
The boolean parameter works the same as with the detach() method.

```java
Animal animal = database.load(rid);
animal = database.detachAll(animal,true);
```
#### Lazy detachAll

_(Since 2.2)_

When calling detachAll(object,true) on a large object tree, the call may become slow, especially when working with remote connections. It will recurse through every link in the tree and load all dependencies. 

To only load parts of the object tree, you can add the @OneToOne(fetch=FetchType.LAZY) annotation like so:

```java
public class LazyParent {

    @Id
    private String id;

    @OneToOne(fetch = FetchType.LAZY)
    private LazyChild child;
...
public class LazyChild {

    @Id
    private ORID id;

    private String name;

    public ORID getId() {
        return id;
    }

    public void setId(ORID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
```
In the above example, when calling detachAll(lazyParent,true), the child variable (if a link is available) will contain a normal LazyChild object, but only with the id loaded. So the name property will be null, as will any other property that is added to the class. The id object can be used to load the LazyChild object in a later stage.

## Execute a query

Although OrientDB is part of NoSQL databases, supports the SQL engine, or at least a subset of it with such extensions to work with objects and graphs.

To know more about the SQL syntax supported go to: [SQL-Query](SQL-Query.md).

Example:

```xml
List<Animal> result = db.query(
  new OSQLSynchQuery<Animal>("select * from Animal where ID = 10 and name like 'G%'"));
```

### Right usage of the graph

OrientDB is a graph database. This means that traversing is very efficient. You can use this feature to optimize queries. A common technique is the [Pivoting](Pivoting-With-Query.md).

### SQL Commands

To execute SQL commands use the <code>command()</code> method passing a OCommandSQL object:

```java
int recordsUpdated = db.command(
  new OCommandSQL("UPDATE Animal SET sold = false")).execute();
```

See all the [SQL Commands](SQL.md).


## Get the ODocument from a POJO

The OObjectDatabaseTx implementation has APIs to get a document from its referencing object:

```java
ODocument doc = db.getRecordByUserObject( animal );
```

In case of non-proxied objects the document will be a new generated one with all object field serialized in it.

## Get the POJO from a Record

The Object Database can also create an Object from a record.

```java
Object pojo = db.getUserObjectByRecord(record);
```
## Schema Generation

Since version 1.5 the Object Database manages **automatic [Schema](Schema.md) generation** based on registered entities.
This operation can be
* manual
* automatic

The ObjectDatabase will generate class properties based on fields declaration if not created yet.

**Changes in class fields (as for type changing or renaming) types won't be updated, this operation has to be done manually**

### Manual Schema Generation

Schema can be generated manually for single classes or entire packages:

*Version 1.6*
```java
db.getMetadata().getSchema().generateSchema(Foo.class); // Generates the schema for Foo class
db.getMetadata().getSchema().generateSchema("com.mycompany.myapp.mydomainpackage");  // Generates the schema for all classes contained in the given package
```

*Version 1.5*
```java
db.generateSchema(Foo.class); // Generates the schema for Foo class
db.generateSchema("com.mycompany.myapp.mydomainpackage"); // Generates the schema for all classes contained in the given package
```

### Automatic Schema Generation

By setting the "automaticSchemaGeneration" property to true the schema will be generated automatically on every class [declaration](Object-2-Record-Java-Binding.md#declare-persistent-classes).

```java
db.setAutomaticSchemaGeneration(true);
db.getEntityManager().registerClass(Foo.class); // Generates the schema for Foo class after registering.
db.getEntityManager().registerEntityClasses("com.mycompany.myapp.mydomainpackage"); // Generates the schema for all classes contained in the given package after registering.
```

class Foo could look like, generating one field with an Integer and ignoring the String field.

```java
public class Foo {
  private transient String field1; // ignore this field
  private Integer field2; // create a Integer
}
```

### Standard schema management equivalent

Having the Foo class defined as following

```java
public class Foo{
private String text;
private Child reference;
private int number;
//getters and setters
}
```
schema generation will create "text", "reference" and "number" properties as respectively STRING, LINK and INTEGER types.

The default schema management API equivalent would be
```java
OClass foo = db.getMetadata().getSchema().getClass(Foo.class);
OClass child = db.getMetadata().getSchema().getClass(Child.class)
foo.createProperty("text",OType.STRING);
foo.createProperty("number",OType.INTEGER);
foo.createProperty("text",OType.LINK, child);
db.getMetadata().getSchema().save();
```

### Schema synchronizing

Since version 1.6 there's an API to synchronize schema of all registered entities.

```java
db.getMetadata().getSchema().synchronizeSchema();
```
By calling this API the ObjectDatabase will check all registered entities and generate the schema if not generated yet. This management is useful on multi-database enviroments

------------------------------------------------------------------------------------
# Old Implementation ODatabaseObjectTx

Until the release 1.0rc9 the Object Database was implemented as the class <code>com.orientechnologies.orient.db.object.ODatabaseObjectTx</code>. This class is deprecated, but if you want to continue to use it change the package to: <code>com.orientechnologies.orient.object.db</code>.

## Introduction

**This implementation and documentation refers to all ODatabaseObjectXXX deprecated classes.**

The Orient Object DB works on top of the [Document-Database](Document-Database.md) and it's able to treat Java objects without the use of pre-processor, byte enhancer or Proxy classes. It uses the simpler way: the Java Reflection. Please consider that the Java reflection in modern Java Virtual Machines is really fast and the discovering of Java meta data is made at first time. Future implementation could use the byte-code enhancement techniques in addition.

Read more about the [Binding between Java Objects and Records](Object-2-Record-Java-Binding.md).

Quick example of usage:
```java
// OPEN THE DATABASE
ODatabaseObjectTx db = new ODatabaseObjectTx ("remote:localhost/petshop").open("admin", "admin");

db.getEntityManager().registerEntityClasses("foo.domain");

// CREATE A NEW ACCOUNT OBJECT AND FILL IT
Account account = new Account()
account.setName( "Luke" );
account.setSurname( "Skywalker" );

City rome = new City("Rome", new Country("Italy"));
account.getAddresses().add(new Address("Residence", rome, "Piazza Navona, 1"));

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

The close() method doesn't close the database but release it to the owner pool. It could be reused in the future.

## Inheritance

Starting from the release 0.9.19 OrientDB supports the [Inheritance](Inheritance.md). Using the ObjectDatabase the inheritance of Documents fully matches the Java inheritance.

Example:
```java
public class Account {
  private String name;
}

public class Company extends Account {
  private int employees;
}
```

When you save a Company object, OrientDB will save the object as unique Document in the cluster specified for Company class. When you search between all the Account instances with:
```java
SELECT FROM account
```

The search will find all the Account and Company documents that satisfy the query.
